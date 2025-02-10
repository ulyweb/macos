## It's about setting up **custom SSL certificates** for **Python’s pip and other tools** on your MacBook Pro. 
### It ensures that your Python and other command-line applications trust a specific Certificate Authority (CA) bundle.

---

## **What This Means**
- The file **`MY-python-cacert-bundle.pem`** is a **custom SSL certificate bundle**.
- The instructions:
  1. **Save the file** into a folder called `certs`.
  2. **Configure pip** to use the custom certificate.
  3. **Set environment variables** so that Python, `pip`, `curl`, and other tools use the certificate automatically.

---

## **Step-by-Step Guide to Set It Up on macOS**

### **1. Create the certs folder**
Open the **Terminal** and run:

```sh
mkdir -p ~/certs
```

This creates a `certs` directory in your home folder (`~`).

---

### **2. Move the certificate file**
If you already have **`My-python-cacert-bundle.pem`**, move it to `~/certs`:

```sh
mv /path/to/My-python-cacert-bundle.pem ~/certs/
```

(Replace `/path/to/` with the actual location of the file.)

---

### **3. Configure pip to use the certificate**
Run the following command:

```sh
pip config set global.cert ~/certs/MY-python-cacert-bundle.pem
```

This tells **pip** to use this custom certificate when making secure HTTPS requests.

---

### **4. Set Environment Variables**
Run these commands in **Terminal** to set the variables for the current session:

```sh
export REQUESTS_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem
export SSL_CERT_FILE=~/certs/MY-python-cacert-bundle.pem
export AWS_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem
export CURL_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem
```

This tells various tools (Python, AWS CLI, cURL) to use the **custom SSL certificate**.

---

### **5. Make These Changes Permanent**
To ensure these settings persist after restarting your terminal, add them to your **`~/.zshrc`** file (since macOS uses Zsh by default):

```sh
echo 'export REQUESTS_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem' >> ~/.zshrc
echo 'export SSL_CERT_FILE=~/certs/MY-python-cacert-bundle.pem' >> ~/.zshrc
echo 'export AWS_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem' >> ~/.zshrc
echo 'export CURL_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem' >> ~/.zshrc
```

Then, apply the changes immediately:

```sh
source ~/.zshrc
```

---

### **6. (Optional) If Using Bash Instead of Zsh**
If you are using Bash instead of Zsh, modify **`~/.bashrc`** instead:

```sh
echo 'export REQUESTS_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem' >> ~/.bashrc
echo 'export SSL_CERT_FILE=~/certs/MY-python-cacert-bundle.pem' >> ~/.bashrc
echo 'export AWS_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem' >> ~/.bashrc
echo 'export CURL_CA_BUNDLE=~/certs/MY-python-cacert-bundle.pem' >> ~/.bashrc
source ~/.bashrc
```

---

## **Why This is Needed**
1. Some networks (corporate or custom setups) require **custom SSL certificates** to verify connections.
2. This setup ensures that `pip`, `requests`, `curl`, and AWS tools can securely communicate over HTTPS.

After following these steps, your **pip and related tools** should now work properly with the provided **custom SSL certificate**! 🚀 Let me know if you have any issues!
