# Deployment Changes Summary

## What Changed

The docker-compose configurations have been updated to use AWS Secrets Manager for database credentials instead of hardcoded values.

## Quick Reference

### Local Deployment (No Changes to Commands)
```bash
cd lcl/
docker-compose -f docker-compose-lcl.yml up -d
```

### Production Deployment (No Changes to Commands)
```bash
cd prd/
docker-compose -f docker-compose-prd.yml up -d
```

**Note:** The `.env` file with AWS credentials is already set up locally. For production on VPN, you need to copy or create the `.env` file on the server.

## What Was Removed from Docker Compose

```yaml
# REMOVED - no longer in docker-compose files:
DB_USER: postgres
DB_PASS: 29XCSdu61eixtdTi2WIkiQ==
```

## What Was Added to Docker Compose

```yaml
# ADDED - new environment variables:
ENV: prd  # or 'local' for lcl
AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
AWS_SECRETS_ENABLED: true
AWS_SECRETS_REGION: ap-southeast-2
```

These values come from the `.env` file in the root directory.

## Production VPN Deployment

**One-time setup on VPN server:**

```bash
# Option 1: Copy .env from local
scp .env user@vpn-server:/path/to/authenticationServiceConfig/

# Option 2: Create .env on server
ssh user@vpn-server
cd /path/to/authenticationServiceConfig
cat > .env << 'EOF'
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
EOF
chmod 600 .env
```

**Then deploy normally:**
```bash
cd prd/
docker-compose -f docker-compose-prd.yml up -d
```

## Files Changed

### authenticationServiceConfig
- ✅ `prd/docker-compose-prd.yml` - Removed DB_USER/DB_PASS, added AWS env vars
- ✅ `lcl/docker-compose-lcl.yml` - Removed DB_USER/DB_PASS, added AWS env vars
- ✅ `.env` - Created with AWS credentials (already in .gitignore)
- ✅ `.env.example` - Template for reference

### expenseManagerConfig
- ✅ `prd/docker-compose-prd.yml` - Removed DB_USER/DB_PASS, added AWS env vars
- ✅ `lcl/docker-compose-lcl.yml` - Removed DB_USER/DB_PASS, added AWS env vars
- ✅ `.env` - Created with AWS credentials (already in .gitignore)
- ✅ `.env.example` - Template for reference

## Security Improvements

**Before:**
- ❌ Database passwords hardcoded in docker-compose files
- ❌ Passwords stored in git repository (even if encrypted)

**After:**
- ✅ Database passwords stored in AWS Secrets Manager (encrypted at rest)
- ✅ AWS credentials in `.env` file (not in git)
- ✅ No secrets in docker-compose files
- ✅ Can rotate database passwords without changing docker-compose

## AWS Secrets Required

Both applications use the same secrets:

```bash
# Create once for both apps
aws secretsmanager create-secret \
    --name local-database-credentials \
    --secret-string '{"USER_NAME":"postgres","PASSWORD":"Yoke1976%"}' \
    --region ap-southeast-2

aws secretsmanager create-secret \
    --name prod-database-credentials \
    --secret-string '{"USER_NAME":"postgres","PASSWORD":"your-prod-password"}' \
    --region ap-southeast-2
```

## Verification

After deploying, check logs to confirm AWS Secrets Manager is working:

```bash
# authService logs
docker logs authservice 2>&1 | grep "AWS Secrets"
# Should see: "AWS Secrets Manager client initialized for region: ap-southeast-2"
# Should see: "Successfully retrieved secret: local-database-credentials" (or prod-)

# expenseManager logs
docker logs expensemanager 2>&1 | grep "AWS Secrets"
```

## Rollback (If Needed)

If you need to rollback, the old docker-compose files are in git history:

```bash
# authenticationServiceConfig
git log --oneline prd/docker-compose-prd.yml
git checkout <previous-commit> prd/docker-compose-prd.yml

# expenseManagerConfig
git log --oneline prd/docker-compose-prd.yml
git checkout <previous-commit> prd/docker-compose-prd.yml
```

## Support

See detailed documentation:
- [AWS_SECRETS_SETUP.md](./AWS_SECRETS_SETUP.md) - Complete setup guide
