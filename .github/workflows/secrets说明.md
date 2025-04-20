# GitHub Actions Secrets 变量获取详细说明

## 1. SERVER_USER

- 说明：服务器的登录用户名。
- 获取方法：
  - 服务器上运行 `whoami`，或使用你平时 SSH 登录服务器的用户名。

## 2. SERVER_HOST

- 说明：服务器的 IP 地址或域名。
- 获取方法：
  - 服务器公网 IP 或域名，例如 `123.123.123.123` 或 `your.domain.com`。

## 3. SERVER_PATH

- 说明：部署到服务器的目标路径。
- 获取方法：
  - 你希望部署的 web 文件夹在服务器上的绝对路径，例如 `/var/www/html` 或 `/home/youruser/webroot`。

## 4. SSH_PRIVATE_KEY 获取方法

1. **生成密钥对（如已有可跳过）**  
   在本地 macOS 终端执行：

    ```sh
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

    按提示操作，生成的私钥默认在 `~/.ssh/id_rsa`，公钥在 `~/.ssh/id_rsa.pub`。

2. **将公钥添加到服务器**  
   把 `~/.ssh/id_rsa.pub` 内容追加到服务器用户的 `~/.ssh/authorized_keys` 文件中：

    ```sh
    cat ~/.ssh/id_rsa.pub | ssh 用户名@服务器IP "cat >> ~/.ssh/authorized_keys"
    ```

    或手动复制粘贴。

3. **获取私钥内容**  
   用文本编辑器打开 `~/.ssh/id_rsa`，复制全部内容（包括 `-----BEGIN ...` 和 `-----END ...`），粘贴到 GitHub Secrets 的 SSH_PRIVATE_KEY。

4. **注意事项**
    - 私钥内容必须完整，不能有多余空格或换行。
    - 不要泄露私钥，仅用于 GitHub Actions 自动化部署。

---

## 5. KNOWN_HOSTS 获取方法

1. **获取服务器主机指纹**  
   在本地 macOS 终端执行：

    ```sh
    ssh-keyscan -H 服务器IP或域名 | grep -v "^#"
    ```

    例如：

    ```sh
    ssh-keyscan -H 123.123.123.123 | grep -v "^#"
    ```

    输出类似如下内容：

    ```sh
    123.123.123.123 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr...
    ```

2. **复制全部输出内容**  
   将输出内容全部复制，粘贴到 GitHub Secrets 的 KNOWN_HOSTS。

3. **作用说明**
    - 该内容用于 GitHub Actions 识别服务器身份，防止中间人攻击。
    - 每次更换服务器或服务器 SSH 配置变更时需重新获取。
