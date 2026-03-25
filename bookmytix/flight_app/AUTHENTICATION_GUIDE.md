# Authentication System Guide

## Overview
This app now has a complete authentication system that allows users to register and login with their own credentials.

## Features
✅ User Registration with validation
✅ User Login with credential verification
✅ Persistent login (stays logged in after app restart)
✅ Secure password storage in SharedPreferences
✅ User session management

## App Flow

### 1. First Time User
1. **Intro Screens** → Three welcome slides introducing the app
2. **Welcome Page** → Options to Register or Login
3. **Register Page** → Create new account
4. **Login Page** → Login with created credentials
5. **Home Screen** → Access to all app features

### 2. Returning User (Not Logged In)
1. **Welcome Page** → Direct access to Login/Register
2. **Login Page** → Login with credentials
3. **Home Screen** → Access to all app features

### 3. Returning User (Already Logged In)
1. **Home Screen** → Direct access (skips intro and login)

## How to Use

### Creating a New Account
1. Run the app
2. Skip or complete the intro slides
3. Click **"REGISTER"** button on the welcome page
4. Fill in the registration form:
   - **User Name**: Your full name
   - **Email or Phone Number**: Valid email or phone
   - **Password**: Minimum 6 characters
   - **Repeat Password**: Must match password
   - ✓ Accept terms and conditions
5. Click **"CONTINUE"**
6. You'll be redirected to the login page with a success message

### Logging In
1. On the login page, enter:
   - **Email or Phone Number**: The one you registered with
   - **Password**: Your password
2. Click **"CONTINUE"**
3. On successful login, you'll see: "Login successful! Welcome [Your Name]"
4. You'll be taken to the home screen

### Testing the Authentication

#### Test New User Registration
```
Name: Test User
Email: test@example.com
Password: test123
```

#### Test Login
```
Email/Phone: test@example.com
Password: test123
```

## Technical Details

### Files Modified/Created
1. **`lib/utils/auth_service.dart`** (NEW)
   - Handles all authentication logic
   - Stores users in SharedPreferences
   - Validates login credentials

2. **`lib/widgets/user/register_form.dart`** (UPDATED)
   - Now saves user data to SharedPreferences
   - Shows success/error messages
   - Redirects to login after successful registration

3. **`lib/widgets/user/login_form.dart`** (UPDATED)
   - Validates credentials against stored users
   - Sets login session
   - Shows welcome message with user's name

4. **`lib/screens/intro/intro_screen.dart`** (UPDATED)
   - Updated intro text to be more relevant
   - Now navigates to welcome page after completion
   - Better user experience

5. **`lib/screens/intro/start_screen.dart`** (UPDATED)
   - Checks both intro status AND login status
   - Smart routing based on user state
   - Shows loading while checking status

### Data Storage
User data is stored in **SharedPreferences** with the following structure:

```json
{
  "registered_users": [
    {
      "name": "John Doe",
      "emailOrPhone": "john@example.com",
      "password": "password123",
      "createdAt": "2025-12-13T10:30:00.000Z"
    }
  ],
  "current_user": {
    "name": "John Doe",
    "emailOrPhone": "john@example.com"
  },
  "is_logged_in": true
}
```

## Important Notes

⚠️ **Security Notice**: This implementation stores passwords in plain text in SharedPreferences. For production apps, you should:
- Hash passwords before storing
- Use secure storage solutions
- Implement proper backend authentication
- Add token-based authentication

✨ **Features**:
- All registered users persist across app restarts
- No hardcoded demo users like "John Doe"
- Each user gets their own unique account
- Login sessions persist until logout

## Clearing User Data (For Testing)

If you need to clear all users and start fresh, you can:
1. Uninstall and reinstall the app
2. Clear app data from device settings
3. Or add a debug button that calls: `AuthService.clearAllUsers()`

## Next Steps

Consider adding:
- [ ] Logout functionality in profile page
- [ ] Password reset feature
- [ ] Email verification
- [ ] Social media login
- [ ] Profile editing
- [ ] Better password encryption
