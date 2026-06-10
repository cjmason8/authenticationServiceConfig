# AWS Secrets Manager Setup for authService

## Overview

The authService now retrieves database credentials from AWS Secrets Manager instead of using hardcoded values in the docker-compose files.

## Changes Made

### Docker Compose Files Updated

**Before:**
```yaml
environment:
  DB_USER: postgres
  DB_PASS: encrypted-password
```

**After:**
```yaml
environment:
  ENV: prd  # or 'local' for lcl
  AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
  AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
  AWS_SECRETS_ENABLED: true
  AWS_SECRETS_REGION: ap-southeast-2
```

Database username and password are now retrieved from AWS Secrets Manager at runtime.

## Files Modified

- `prd/docker-compose-prd.yml` - Production configuration
- `lcl/docker-compose-lcl.yml` - Local configuration
- `.env` - AWS credentials (already in .gitignore)
- `.env.example` - Template for AWS credentials

## AWS Secrets Required

### Local Development Secret
```bash
aws secretsmanager create-secret \
    --name local-database-credentials \
    --secret-string '{"USER_NAME":"postgres","PASSWORD":"your-local-password"}' \
    --region ap-southeast-2
```

### Production Secret
```bash
aws secretsmanager create-secret \
    --name prod-database-credentials \
    --secret-string '{"USER_NAME":"postgres","PASSWORD":"your-production-password"}' \
    --region ap-southeast-2
```

## AWS Credentials Setup

### Local Development

AWS credentials are stored in `.env` file (already exists, not in git):
```bash
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
```

Docker Compose automatically loads this file.

### Production Deployment on VPN

1. **Copy .env to VPN server:**
   ```bash
   scp .env user@vpn-server:/path/to/authenticationServiceConfig/
   ```

2. **Or create .env directly on server:**
   ```bash
   ssh user@vpn-server
   cd /path/to/authenticationServiceConfig
   cp .env.example .env
   # Edit .env with actual credentials
   chmod 600 .env
   ```

3. **Deploy:**
   ```bash
   cd prd/
   docker-compose -f docker-compose-prd.yml up -d
   ```

## How It Works

1. Docker Compose reads `.env` file in the root directory
2. Environment variables are passed to the container
3. Application's `AwsSecretsService` uses these credentials
4. Database username/password retrieved from AWS Secrets Manager based on `ENV` value:
   - `ENV=local` → uses `local-database-credentials` secret
   - `ENV=prd` → uses `prod-database-credentials` secret

## Security Notes

✅ `.env` file is in `.gitignore` (credentials not in git)  
✅ Database passwords stored encrypted in AWS Secrets Manager  
✅ No hardcoded passwords in docker-compose files  
🔄 Rotate AWS access keys every 90 days  

## Deployment Commands

### Local
```bash
cd lcl/
docker-compose -f docker-compose-lcl.yml up -d
```

### Production
```bash
cd prd/
docker-compose -f docker-compose-prd.yml up -d
```

## Troubleshooting

### "The security token included in the request is invalid"
- Check `.env` file exists and has correct AWS credentials
- Verify IAM user has Secrets Manager permissions

### "Secret not found"
- Create the required secrets in AWS Secrets Manager (see commands above)

### Container can't reach AWS
- Verify network allows outbound HTTPS (443) to AWS
- Check `secretsmanager.ap-southeast-2.amazonaws.com` is reachable
