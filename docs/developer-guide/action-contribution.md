---
layout: default
title: How to contribute to the actions repos
parent: Developer Guide
nav_order: 3
---

# How to contribute to the actions repos
1. Firstly, you need to fork the action repository which you want to contribute.
2. Make changes to the current logic and add readable comments where and when it’s necessary.
3. You will need to add integration tests which can trigger your logic. The integration tests can be added in the workflow definition stored in the .github/workflows directory.
4. When you submit the PR for the action codes, you will need to list out the reasons for these changes and their influences.
5. You also need to add related documentation PR in the documentation repository. For example, if you add a new option for a specific action, you need to describe the new added input in the documentation.
6. The README.md in the action repository should only contain just enough material for the users to start using your work. If you think it’s necessary to make changes in the README.md, you can make a commit with your action codes.
