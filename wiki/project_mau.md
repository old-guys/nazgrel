## project develop workflow

project deploy guideline

* 收集 版本需求
* 协商优先级
* 定义发布线（协同相关项目, 和人员）
* 分配 需求 ticket
* 协同开发进度
* 调整发布分支
* 确认发布相关资源（dev, requirements, qa, product manager）
* 发布
* review

## project develop guideline

### Git Protocol

A guide for programming within version control.

Maintain a Repo
---------------

* Avoid including files in source control that are specific to your
  development machine or process.
* Delete local and remote feature branches after merging.
* Perform work in a feature branch.
* Rebase frequently to incorporate upstream changes.
* Use a [pull request] for code reviews.

[pull request]: https://help.github.com/articles/using-pull-requests/

Write a Feature
---------------

Create a local feature branch based off master.

    git checkout master
    git pull
    git checkout -b <branch-name>

Rebase frequently to incorporate upstream changes.

    git fetch origin
    git rebase origin/master

Resolve conflicts. When feature is complete and tests pass, stage the changes.

    git add --all

When you've staged the changes, commit them.

    git status
    git commit --verbose

Write a [good commit message]. Example format:

    Present-tense summary under 50 characters

    * More information about commit (under 72 characters).
    * More information about commit (under 72 characters).

    http://project.management-system.com/ticket/123

If you've created more than one commit, use a rebase to squash them into
cohesive commits with good messages:

    git rebase -i origin/master

Share your branch.

    git push origin <branch-name>

Submit a [GitHub pull request].

Ask for a code review in the project's chat room.

[good commit message]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[GitHub pull request]: https://help.github.com/articles/using-pull-requests/

Review Code
-----------

A team member other than the author reviews the pull request. They follow
[Code Review](/code-review) guidelines to avoid
miscommunication.

They make comments and ask questions directly on lines of code in the GitHub
web interface or in the project's chat room.

For changes which they can make themselves, they check out the branch.

    git checkout <branch-name>
    ./bin/setup
    git diff staging/master..HEAD

They make small changes right in the branch, test the feature on their machine,
run tests, commit, and push.

When satisfied, they comment on the pull request `Ready to merge.`

Merge
-----

Rebase interactively. Squash commits like "Fix whitespace" into one or a
small number of valuable commit(s). Edit commit messages to reveal intent. Run
tests.

    git fetch origin
    git rebase -i origin/master

Force push your branch. This allows GitHub to automatically close your pull
request and mark it as merged when your commit(s) are pushed to master. It also
 makes it possible to [find the pull request] that brought in your changes.

    git push --force origin <branch-name>

View a list of new commits. View changed files. Merge branch into master.

    git log origin/master..<branch-name>
    git diff --stat origin/master
    git checkout master
    git merge <branch-name> --ff-only
    git push

Delete your remote feature branch.

    git push origin --delete <branch-name>

Delete your local feature branch.

    git branch --delete <branch-name>

[find the pull request]: http://stackoverflow.com/a/17819027

### git workflow

大家**随时**留意一下 gitlab Merge Requests 列表

分支列表创建惯例

    feature/xxxx
    enhance/xxxx
    refactor/xxxx
    support/xxxx
    hotfix/xxxx

例如
    enhance/revisit_log_report_can_comment 9fba253 fix #10983, 跟进记录报表，当显示“没有了”，仍然可以加载出数据；当显示”加载更多“时，无法加载出数据
    enhance/select_to_select2_2015_10_26   446443b backbone view use selector like @$(selector) been recommend
    feature/simple_couter                  7c4e8ba append doc nazgrel_counter.md

开发中 按照实际场景 大概按照这样的流程
member a launch one merge request

    git fetch
    git checkout master
    git pull --rebase origin master
    git checkout -b LABEL/branch_name

    # coding
    git rebase origin/master
    git push origin ${label}/branch_name -u

    # visit gitlab open a merge request !${merge_request_id} and ensure should no conflict contains

    when you found below text pls resolve the conflict

       This merge request contains merge conflicts
       Please resolve these conflicts or merge this request manually.


    git checkout development
    git pull --rebase origin development
    git merge ${label}/branch_name development

review code

    team member visit http://gitlab.nazgrel.com/nazgrel_server/vcooline_nazgrel/merge_requests/${merge_request_id}
    discuss changes within merge request !${merge_request_id} and write comment

handle merge request

    # ..


refer [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
