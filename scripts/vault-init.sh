#!/bin/bash
# Check if vault is already initialized or not
is_init=`kubectl exec -it vault-0 -- sh -c "vault status | grep Initialized | tr -s ' ' | cut -d ' ' -f2 | tr -d '\n'"`
if [[ $is_init == "true" ]]
then
    echo "Vault is already initialized"
    echo "Exit Setup job.."
    exit 0
else
    # Initialize Vault with five key shares and three key threshold
    kubectl exec vault-0 -- vault operator init -format=json > cluster-keys.json
    # Capture the Vault unseal keys and root token
    VAULT_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
    VAULT_UNSEAL_KEY_1=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[0]")
    VAULT_UNSEAL_KEY_2=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[1]")
    VAULT_UNSEAL_KEY_3=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[2]")
    # Unsealing Vault
    kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY_1
    kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY_2
    kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY_3
    # Creating k8s secret containing vault credentials
    kubectl create secret generic vault-credentials --from-literal=vault-root-token=$VAULT_ROOT_TOKEN --from-literal=vault-unseal-key-1=$VAULT_UNSEAL_KEY_1 --from-literal=vault-unseal-key-2=$VAULT_UNSEAL_KEY_2 --from-literal=vault-unseal-key-3=$VAULT_UNSEAL_KEY_3
    # Login to vault
    kubectl exec vault-0 -- vault login $VAULT_ROOT_TOKEN > /dev/null 2>&1
    # Enable kubernetes authentication method
    kubectl exec vault-0 -- vault auth enable kubernetes
    # Configure the Kubernetes authentication method to use the location of the Kubernetes API
    kubectl exec vault-0 -- vault write auth/kubernetes/config kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
    # Create the eso namespace
    # kubectl create ns external-secrets -- Namespace should already exist on GKE assuming a successful ESO deploy
    # Create eso-vault-sa service account to be used by the eso pods
    kubectl -n default create sa eso-vault-sa
    # Create vault policy that enables read and write capabilities for secrets at specific path
    cat << EOF > eso-vault-policy.hcl
    path "secret/*" { 
      capabilities = ["create", "read", "update", "list"]
    }
EOF
    kubectl cp eso-vault-policy.hcl vault-0:/vault/file/eso-vault-policy.hcl
    kubectl exec vault-0 -- vault policy write eso-vault-policy /vault/file/eso-vault-policy.hcl
    ## Create a vault Kubernetes authentication role,that connects the Kubernetes service account and vault policy
    kubectl exec vault-0 -- vault write auth/kubernetes/role/eso-role bound_service_account_names=eso-vault-sa bound_service_account_namespaces=default policies=eso-vault-policy ttl=24h
    kubectl exec vault-0 -- vault secrets enable -version=2 kv -path=secret
fi