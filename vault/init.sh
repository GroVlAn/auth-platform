AUTH_#!/bin/sh

set -e

export VAULT_ADDR=http://vault:8200

while ! vault status > /dev/null 2>&1; do
    echo "Ожидание Vault..."
    sleep 2
done

vault login root

if ! vault token lookup > /dev/null 2>&1; then
    echo "Ошибка: не удалось войти в Vault"
    exit 1
fi

vault secrets enable -path=secret kv-v2 || echo "Движок secret уже включен"

vault kv put secret/auth/tokens \
    secret_key="$SECRET_KEY" \
    token_refresh_end_ttl="$TOKEN_REFRESH_END_TTL" \
    token_access_end_ttl="$TOKEN_ACCESS_END_TTL"

vault kv put secret/auth/redis \
    host="$AUTH_REDIS_HOST" \
    addr="$AUTH_REDIS_ADDR" \
    password="$AUTH_REDIS_PASSWORD" \
    db="$AUTH_REDIS_DB"

vault kv put secret/auth/hasher \
    time="$HASH_TIME" \
    memory="$HASH_MEMORY" \
    threads="$HASH_THREADS" \
    key_len="$HASH_KEY_LEN" \
    salt_len="$HASH_SALT_LEN"

vault kv put secret/user/postgres \
    username="$DB_USER_USERNAME" \
    password="$DB_USER_PASSWORD" \
    db_name="$DB_USER_DB_NAME"

vault kv put secret/user/hasher \
    time="$HASH_TIME" \
    memory="$HASH_MEMORY" \
    threads="$HASH_THREADS" \
    key_len="$HASH_KEY_LEN" \
    salt_len="$HASH_SALT_LEN"

vault kv put secret/access/postgres \
    username="$DB_ACCESS_USERNAME" \
    password="$DB_ACCESS_PASSWORD" \
    db_name="$DB_ACCESS_DB_NAME"

echo "Проверка сохраненных секретов:"
vault kv get secret/auth/tokens
vault kv get secret/auth/redis 
vault kv get secret/user/postgres
vault kv get secret/user/hasher
vault kv get secret/access/postgres

echo "Инициализация Vault завершена успешно!"