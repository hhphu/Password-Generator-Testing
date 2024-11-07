# Test plan for Password Generator
URL: https://www.security.org/password-generator/

## Set up
### Python3
- Create a virtual environment for the project

```bash
# Install venv if not yet
sudo apt install python3.10-venv

# Create a virtual environemnt for the project
python3 -m venv .venv
``` 

- If successful, the folder `.venv` should be created. Run `ls -la` to see the folder.

- Activate the virtual environment

```bash
source .venv/bin/activate
```

- After activation, we should see the virtual environemnt name in the prompt of the command `(venv)`

- Install packages `pip install -r requirements.txt`

For more information, please visit [here](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html).

## Execute test cases

- To execute the whole test suite, run

```bash
robot -d results PasswordGenerator.robot

# results is the folder that stores the output of the test run
# PasswordGenerator.robot: Test suite name
```

- To execute a specifit within the test 

```bash
robot -d results -t $TESTCASE_NAME $TESTSUITE_NAME
```

- To execute test cases with a specific tag

```bash
robot -d results --include $TAG $TESTSUITE_NAME
```

## Structures
There will be two main folders: **Resources** & **Scripts**

### Resources


## Challenges/Issues
1. When clicking the copy icon, the text is copied to the clipboard!. However, when trying to access the clipboard, I got a pop-up asking for permissions. Due to security reasons, automating granting the permission is not viable through Robot Framework. So I had to do a workaround, running Python to independtly get the content of the clipboard.

```bash
sudo apt-get install xclip
pip install pyperclip
```
2. I was having challenges with the regex when testing the passwords with only symbols.
From [this](https://stackoverflow.com/questions/54410228/how-to-write-a-regular-expression-utilizing-the-robot-framework-to-find-replace), I learned that RobotFramework stips one level of backlash `\` before using the value is evaluated. Hence, instead of regularly escaping character `\[`, I had to add another backlash, resulting in `\\[`. Hence the final regex for symbols look like this `[!@#$%^&*\\(\\)_+\\{\\}\\[\\]:;"'<>?,.\\/\\|`~-]`

3. Each functionalities of the features has been verified. When testing the combinaions of passwords requirements, the results are not consistent. Still working on debugging to yield more consistent passed results.
