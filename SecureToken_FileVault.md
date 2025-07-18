Managing **SecureToken** and **FileVault ownership** via `sysadminctl` requires special handling. Below is a step-by-step guide to:

1. ✅ Create a user with a SecureToken
2. 🔐 Transfer SecureToken from one user to another
3. 🗝 Enable FileVault and make the new user a FileVault-enabled user (owner or contributor)

---

## 🧱 Background: SecureToken & FileVault

* **SecureToken** is required for a user to unlock **FileVault-encrypted disks**.
* The **first SecureToken user** (usually the initial admin) can grant a token to others.
* Only **SecureToken-enabled users** can unlock the disk at boot or administer FileVault.

---

## ✅ Step 1: Check Existing SecureToken Holders

First, list users and check who has SecureToken:

```bash
sudo sysadminctl -secureTokenStatus USERNAME
```

**Example:**

```bash
sudo sysadminctl -secureTokenStatus johnsmith
```

You’ll see either:

* `Secure token is ENABLED for user johnsmith`
* `Secure token is DISABLED for user johnsmith`

---

## 🔁 Step 2: Grant SecureToken to New User

You must authenticate as a **SecureToken-enabled user** to give SecureToken to others:

```bash
sudo sysadminctl -secureTokenOn NEWUSER -password NEWUSERPASSWORD -adminUser TOKENUSER -adminPassword TOKENUSERPASSWORD
```

* `NEWUSER` = the user you want to give SecureToken to
* `TOKENUSER` = an existing SecureToken-enabled user

**Example:**

```bash
sudo sysadminctl -secureTokenOn newadmin -password MyNewUserPass123 -adminUser johnsmith -adminPassword OldUserPass!
```

---

## 🔐 Step 3: Enable FileVault for the New User

Once the new user has SecureToken, you can enable FileVault and authorize them for unlock.

### Option 1: Via Terminal (TCC may block interaction; GUI is easier)

```bash
sudo fdesetup add -user newadmin
```

This will prompt for the password interactively. To do it non-interactively:

```bash
sudo fdesetup add -usertoadd newadmin -user adminwithtoken -password adminpassword
```

⚠️ Replace:

* `newadmin` with the user you’re adding to FileVault
* `adminwithtoken` and `adminpassword` with existing SecureToken admin

---

## 📌 Summary Script Snippet (Example Flow)

```bash
# Create the user
sudo sysadminctl -addUser newadmin -fullName "New Admin" -password MyNewUserPass123

# Grant SecureToken from existing user (johnsmith) to newadmin
sudo sysadminctl -secureTokenOn newadmin -password MyNewUserPass123 -adminUser johnsmith -adminPassword OldUserPass!

# Add newadmin to admin group (optional)
sudo dseditgroup -o edit -a newadmin -t user admin

# Enable FileVault for newadmin
sudo fdesetup add -usertoadd newadmin -user johnsmith -password OldUserPass!
```

---

## 🧠 Tips

* Ensure `johnsmith` has a SecureToken before starting.
* SecureToken granting **only works interactively** — you cannot grant SecureToken to a user without using credentials of an existing SecureToken user.
* FileVault users are managed via `fdesetup` and must also have SecureToken.
* For headless or automated workflows, consider using MDM tools with SecureToken escrow support.

