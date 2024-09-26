Git & GitHub catchup
================

# Questions from Assignment 1:

1.  **What are the differences between GitHub, GitLab and BitBucket?
    When would we use each one or are they all essentially do the same
    thing, just from different developers?**

    GitHub, GitLab, and BitBucket are similar cloud-based Git hosting
    platforms. The main reason Dr. Campbell and I chose GitHub at the
    beginning of the class is that we wanted to try the setup described
    in Happy Git and GitHub for the useR.

    I’ve also heard that some other computer science classes use it, and
    even more are considering moving to GitHub classroom.

    The main advantage of BitBucket is that it integrates well with
    other Atlassian products like Jira, which is used for project
    management. A disadvantage is that the free version can only include
    5 members.

    Does anyone in the class have experience working in GitLab or
    BitBucket? What are some of the similarities and differences?

2.  **RStudio seems to work really well compared to some other
    programmings language IDE’s. Why was so much development done for R
    to work well with Github?**

    GitHub is widely used for [R package
    development](https://r-pkgs.org/software-development-practices.html#sec-sw-dev-practices-ci).

3.  **I’m going to do some research into Git clients they look very
    useful any recommendations?**

    They do look useful! I haven’t used one yet. Has anyone else in the
    class? Would you recommend it to classmates? Would you like to show
    us?

    Jenny Bryan includes some recommendations in [Happy Git and GitHub
    for the useR](https://happygitwithr.com/git-client). Personally, I’d
    try [GitKraken](https://www.gitkraken.com/) because it has a cool
    name. And it is Jenny Bryan’s top recommendation.

4.  **Do our R files save automatically, does pushing it to GitHub save
    it for me or do I need to manually save my file each time I edit
    it?**

    R does not save your files automatically. You can change [this
    setting.](https://posit.co/blog/rstudio-1-3-the-little-things/) The
    general best practice for this course would be to save your file,
    then commit it, then push it to GitHub.

5.  **Also what does staged mean? Why does the “M” move from the right
    status to the left status?**

    Staged means that you are marking the files to go into the next
    commit. There are 3 states that files can be in: [modified, staged,
    or
    committed](https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F).
    In the RStudio git pane, M stands for modified, A stands for added,
    D is for deleted, and a ? means that Git is not tracking the file as
    part of the version control project. There is an old but helpful
    [video](https://posit.co/resources/videos/managing-part-2-github-and-rstudio/)
    on GitHub and RStudio by Garrett Grolemund.

6.  **Before this course, I was somewhat familiar with GitHub as it’s
    widely used for game development. In my mind, I did not think one
    could use GitHub for anything other than software development. The
    article by Bryan mentions that it in fact can, but one may encounter
    issues when trying to use GitHub for a purpose other than developing
    software. This leads to my question of, what problems will I run in
    to when using GitHub to sort and analyze data?**

7.  **The article described why GitHub and RStudio worked well together
    in a group and I understand why we are using them in this
    environment when we are all going to be collaborating on the same
    project. However, I like to think that I’m a semi organized person
    and I’m curious on what naming system we are going to use so that we
    are all on the same page when we pull documents to work on. aka, the
    question - What naming system are we all going to use to stay
    organized?**

8.  **Furthermore, what would happen if someone is working on a file and
    someone else pulls it from GitHub and then they both push the files
    they were working on?**

9.  **For the beginning part of the course we will be working
    individually in our repositories, when we start working on the group
    work will we all be working in the same repository? I don’t think I
    completely understand how the collaboration works in GitHub.**

10. **Question: How do I perform in-place operations on data frames in R
    using tidyverse? As far as I can tell, common tidyverse functions on
    tibbles (e.g., mutate) duplicate the data in the heap and perform
    in-place operations on the new copy. For instance, flights \<-
    mutate(flights, gain = dep_delay - arr_delay) copies the heap data
    referenced by flights, modifies this copy, deallocates the original
    data referenced by flights, and assigns the copy back to the flights
    reference. Can we do this in-place instead (like panda’s in-place
    keyword in Python)?**

11. **When calling the pipe operator, is the interpreter smart enough to
    only copy data in the heap once, or does it do so multiple times?**

12. **Is GitHub the best way to do this?**

13. **What is the main disadvantage in using GitHub?**

14. **I am interested to know why GitHub was chosen for this course? Are
    there other sites available for collaborating in R or is this the
    only/best one?**
