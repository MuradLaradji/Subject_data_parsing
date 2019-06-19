1. Install Git
      [https://git-scm.com/downloads](https://www.google.com/url?q=https://git-scm.com/downloads&sa=D&source=hangouts&ust=1560993390440000&usg=AFQjCNHs7tDnaw8yG4kfIFo8SKqpOzL1Ww) 

2. Navigate to your project directory in Windows Explorer

3. Create a new text file in the directory and copy the following text into it

      ``` 
      \.idea/
      \venv/
      ```

4. Close the file and rename it to `.gitignore` (without the `.txt`)

5. Two finger click and click Git Bash

6. A black window should open up

7. Type in these commands one by one

   ```shell
   git config --global user.name "Murad Laradji"
   
   git config --global user.email "whatever your email is"
   
   git config --global core.autocrlf true
   
   git init
   
   git add .
   
   git commit -m "Initial commit"
   ```

8.  Close the Git Bash window

9. Go to github.com and make an account

10. Make a new private repository and title it exactly how your project folder is titled on your computer

11. do NOT initialize the repository with a readme and do not write a description

12. Once the repository is created, the next page should load  with some code on it

13. Copy the code from the "push an existing repository from the command line"

14. Open the Git Bash window again and run those two commands

15. On the Github website, you should now see all of your code and files and stuff

16. Invite me as a collaborator to the repository
