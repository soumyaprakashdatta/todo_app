# ToDo App

This codebase is for a TODO app, supported by Back4App backend. To set this up please follow steps below

# Key features

- Crate Todo
- Update Todo
- View Todo details
- Delete Todo
- Mark Todo as complete/ pending
- App state is always in sync with Back4App database

# Set up Back4App 

1. Create account
2. Create a class named **todo**
3. Create following columns
   - **title** (string)
   - **description** (string)
   - **done** (boolean)
4. Go to "App Settings" > "Security & Keys" section to find following properties that we will need later to connect to the table from this app
   - **Application ID**
   - **Client Key**


# Connect to Back4App class from flutter app

1. Create a file named `api_keys.json` at the root label of project
2. File structure should look as follows -

```json
{
    "APPLICATION_ID": "Application ID from Back4app",
    "CLIENT_KEY": "Client Key from Back4app"
}
```

# Run project

1. If you have `make` installed, then you can run following <br/>
```make run``` 
1. Otherwise, you can run the app using <br/>
```flutter run --dart-define-from-file=api_keys.json```