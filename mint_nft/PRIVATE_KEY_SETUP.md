# 私钥配置说明

## 环境变量配置

在项目根目录创建 `.env` 文件，添加以下配置：

```bash
# 私钥配置（推荐）
# 格式：suiprivkey...
VITE_PRIVATE_KEY=suiprivkey1qzw2l9ymq56g42dqu8en44v4mcnthd2lqvxd2mn3veekhhd37vekj2vecq1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqfqlpgzquu3ysa62x77m60ly24x8n8edft2hd8vp9q6r8f9

# 助记词配置（备选）
# 格式：12个或24个单词
VITE_PUBLIC_MNE=word1 word2 word3 word4 word5 word6 word7 word8 word9 word10 word11 word12

# NFT 包 ID
VITE_PROJECT_NFT_PACKAGE_ID=0xc9c6b044a878bea54e8c2908fef5e1494a559f638347d3d3841f83b820172168

# Walrus API 配置
VITE_PUBLISHER_URL=https://publisher.walrus-testnet.walrus.space
VITE_AGG_URL=https://aggregator.walrus-testnet.walrus.space
```

## 获取私钥的方法

### 方法1：从 Sui 密钥库导出私钥

```bash
# 列出所有密钥
sui keytool list

# 导出私钥（替换 YOUR_KEY_IDENTITY）
sui keytool export --key-identity YOUR_KEY_IDENTITY
```

### 方法2：从现有密钥文件导入

```bash
# 导入私钥到 Sui 密钥库
sui keytool import "suiprivkey..." ed25519 --alias my-key

# 然后导出
sui keytool export --key-identity my-key
```

### 方法3：生成新的密钥对

```bash
# 生成新的 Ed25519 密钥对
sui keytool generate ed25519 --alias new-key

# 导出私钥
sui keytool export --key-identity new-key
```

## 代码修改说明

代码已经修改为支持两种格式：

1. **私钥格式**：以 `suiprivkey` 开头的 Bech32 编码字符串
2. **助记词格式**：12个或24个单词的助记词

代码会自动检测格式并使用相应的方法创建密钥对：

```typescript
// 检查是否为私钥格式（以 suiprivkey 开头）
if (privateKeyOrMnemonic.startsWith('suiprivkey')) {
  keypair = Ed25519Keypair.fromSecretKey(privateKeyOrMnemonic);
} else {
  // 否则当作助记词处理
  keypair = Ed25519Keypair.deriveKeypair(privateKeyOrMnemonic);
}
```

## 安全注意事项

⚠️ **重要安全提醒**：

1. 永远不要将私钥提交到版本控制系统
2. 确保 `.env` 文件已添加到 `.gitignore`
3. 在生产环境中使用环境变量或安全的密钥管理服务
4. 定期轮换私钥
5. 不要在客户端代码中硬编码私钥 
