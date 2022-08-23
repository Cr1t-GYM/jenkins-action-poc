---
layout: default
title: How to test the source code
parent: Developer Guide
nav_order: 2
---

# How to test the source code
The action codes are difficult to debug because its running environment cannot be mocked locally. Therefore, the only method to see whether your code runs as expected is pushing the changes to GitHub and let GitHub Actions runners test them. Follow the steps below to debug your codes.
1. Fork the action repository you want to contribute.
2. Add changes to the current logic and push it to your forked repository.
3. For a specific action, you can add integration tests in the GitHub Action workflow definitions. They are stored in the .github/workflows directory. Remember you need to set up your tests correctly which can be triggered by a push so that you can see it run after you have pushed the changes. 
4. After you have pushed the changes, you can visit the Actions page in your forked repository where you can see their full logs after it reaches the end of the run.
