### It's about setting up **custom SSL certificates** for **Python’s pip and other tools** on your MacBook Pro. It ensures that your Python and other command-line applications trust a specific Certificate Authority (CA) bundle.


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
1. Some networks or custom setups require **custom SSL certificates** to verify connections.
2. This setup ensures that `pip`, `requests`, `curl`, and AWS tools can securely communicate over HTTPS.

🚀 After following these steps, your **pip and related tools** should now work properly with the provided **custom SSL certificate**!

#
  
> [!NOTE]
> # 🎯 On macOS (especially with the M3 chip), `pip` may refer to an older Python version or may not be installed globally. Instead, **`pip3`** is the correct command to use for managing packages with **Python 3**.  

### **What to Do Instead?**  
Since `pip3` works but `pip` does not, use this command instead for Step 3:  

```sh
pip3 config set global.cert ~/certs/Intuitive-python-cacert-bundle.pem
```

This ensures **pip3** (which is associated with Python 3) uses the custom SSL certificate.  

### **Do I Need to Fix pip?**  
Not necessarily! As long as `pip3` is working, you're good to go. But if you want `pip` to work as well, you can check if it’s installed by running:  

```sh
which pip
```
or  
```sh
python3 -m ensurepip --default-pip
```

If `pip` is missing, you can create an alias in your `~/.zshrc` or `~/.bashrc` file:  

```sh
echo 'alias pip="pip3"' >> ~/.zshrc
source ~/.zshrc
```

Now, `pip` will behave like `pip3` whenever you use it.

#

> [!NOTE]
> # 🎯 The error **"CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate"** means that your system is having trouble verifying the SSL certificate when trying to download the Google Cloud SDK.  
This is likely due to the custom certificate setup you applied earlier. The **Google Cloud SDK** installer might not be picking up the correct CA certificate bundle.  

---

### **🔧 Fix: Ensure the System Trusts the Right Certificates**  

#### **1️⃣ Update Python’s SSL Certificates**  
Since **Homebrew Python** manages its own SSL certificates, you need to update them manually:  

Run this command in your **Terminal**:  

```sh
/Applications/Python\ 3.11/Install\ Certificates.command
```

(Adjust the version `3.11` if you're using a different one.)

If you installed Python via Homebrew, use:  

```sh
/opt/homebrew/bin/python3 -m pip install --upgrade certifi
```

Then, set Python to use the updated certificates:  

```sh
export SSL_CERT_FILE=$(python3 -m certifi)
```

---

#### **2️⃣ Manually Set Environment Variables for Google Cloud SDK**  
The Google Cloud SDK might not be recognizing your certificate settings. Try explicitly setting them:  

```sh
export REQUESTS_CA_BUNDLE=~/certs/Intuitive-python-cacert-bundle.pem
export SSL_CERT_FILE=~/certs/Intuitive-python-cacert-bundle.pem
export CURL_CA_BUNDLE=~/certs/Intuitive-python-cacert-bundle.pem
```

Then retry the installation:  

```sh
brew install google-cloud-sdk
```

---

#### **3️⃣ Verify OpenSSL and Homebrew Certificates**  
Homebrew has its own **OpenSSL** and CA certificates. Ensure they're installed and up to date:  

```sh
brew install openssl
brew install ca-certificates
brew update && brew upgrade
```

After updating, link the correct CA bundle:  

```sh
export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem
export REQUESTS_CA_BUNDLE=/opt/homebrew/etc/ca-certificates/cert.pem
```

Then retry:  

```sh
brew install google-cloud-sdk
```

---

#### **4️⃣ Restart the Terminal & Try Again**
If the above steps don’t work right away, restart the **Terminal**, then try installing again:

```sh
brew install google-cloud-sdk
```

---

### **✅ Summary: What We Did**
1. **Updated Python's SSL certificates** (which pip and requests use).  
2. **Set environment variables** so Python and cURL use the correct certificate.  
3. **Ensured Homebrew’s OpenSSL & certificates were updated**.  
4. **Restarted the terminal and retried the installation**.  

This should resolve the issue.
