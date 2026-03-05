# Apropo Task Benchmark Template

This document defines the expected structure and fields for Apropo CSV file

---
## General rules
- Module, epic, task is just a level of detail
- If task has module but not epics, then task will became epic to keep order
- Only difference is description which is the last task
- There is always technical module (even when there are phases technical is top level)
- Description has to be minimal, most important information without full sentences. Details are in main document, here it is hint for person who will estimate

## Templates
### CSV Simple Template

```
level_1, level_2, Description
Technical,
,Authorization, Login With Email and password
,RBAC
User Management
,Add User to system
```

### CSV With different levels

```
level_1, level_2, level_3, Description
Technical,
,Authorization,, Login With Email and password
,RBAC,, Simple roles
Admin Panel
,User Management
,,Add User to system, Simple form
```

### CSV Template with Phase

```
level_1, level_2, level_3, level_4, Description
Technical,,,,
,Authroization,,,,
,RBAC,,,,
Phase1,,,,
,Admin Panel,,,,
,,User Management,,,
,,,Add User to system, Simple form
Phase2,,,,
```


