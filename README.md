# **Perfolio Pipeline**

_This is the CI/CD pipeline only. The actual code for the front and backend is stored in a 
separate repo._



READMEs are great, but check out the proper docs here: 
[https://staneslevski.github.io/perfolio-pipeline/][https://staneslevski.github.io/perfolio-pipeline/]

The project will use a base terraform template in the root directory and will then pull in 
extra files in order to manage and organise all the modules of the project's infrastructure.

Since terraform does not seem to have an easy function to separate files into subdirectories, 
you are forced to either create multiple files in the same directory, or to create re-usable 
modules for your terraform.

It is bad practice to use modules to split code along simplistic lines (see Terraform docs 
[here](https://www.terraform.io/docs/modules/index.html#when-to-write-a-module 
"Terraform Docs: When To Write A Module")
) and so because the bulk of the project is just a pipeline, I have split the units into separate 
files.

Because AWS CodeBuild build projects share a lot of the same configuration and there will be 
multiple build steps in the project, I have a created a re-usable build project module.