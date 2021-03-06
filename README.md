# PSJira

[![Build status](https://ci.appveyor.com/api/projects/status/rog7nhvpfu58xrxu?svg=true)](https://ci.appveyor.com/project/JoshuaT/psjira)

PSJira is a Windows PowerShell module to interact with [Atlassian JIRA](https://www.atlassian.com/software/jira) via a REST API, while maintaining a consistent PowerShell look and feel.

---

## Project update: April 2016
I've gone through a move and a job change in the last month, and as a result, I no longer have access to a working instance of JIRA. As you can imagine, this limits my ability to enhance the module a bit.

I'd be willing to spin up a small home JIRA server to continue development on this, but my real-life budget is stretched to the breaking point, and I honestly can't afford the price tag even for the most basic JIRA license. If anyone has the ability to grant me a user account on a JIRA instance with enough permissions to test this stuff (create and modify users, issues, filters, etc.), drop me a PM on Reddit (replicaJunction).

Meanwhile, I will continue to troubleshoot and provide support to the best of my ability.

Because I don't have the ability to test the module against a real JIRA instance right now, it is *absolutely critical* that pull requests pass all CI tests before they are merged!

Thanks for all your kind words on this project. I've invested too much in this just to let it die.

-replica

---

## Requirements

This module has a hard dependency on PowerShell 3.0.  I have no plans to release a version compatible with PowerShell 2, as I rely heavily on several cmdlets and features added in version 3.0.

## Downloading

In PowerShell 5, it's very simple to download the latest public release of this module:

```powershell
Install-Module PSJira
```

If you're using PowerShell 3 or 4, you can download this module from the Download Zip button on the right.  You'll need to extract the PSJira folder to your $PSModulePath.  Normally, this is at C:\Users\<username>Documents\WindowsPowerShell\Modules.

You can also always feel free to clone the module directly in Git.

## Getting Started

Before using PSJira, you'll need to define your JIRA server URL.  You will only need to do this once:

```powershell
Set-JiraConfigServer "https://jira.example.com"
```

## Usage

Check out the [Getting Started](https://github.com/replicaJunction/PSJira/wiki/Getting-Started) page on the project wiki for detailed use information.

## Planned features
* Support for multiple config files and/or alternate config file locations
* Possible support for OAuth in addition to HTTP Basic authentication

## Contributing
Want to contribute to PSJira?  Great!  I'm accepting pull requests against the *dev* branch.

Here are a couple of notes regarding contributions:
* PSJira relies heavily upon Pester testing to make sure that changes don't break each other.  Please respect the tests when coding against PSJira.
  * Pull requests are much more likely to be accepted if all tests pass.
  * If you write a change that causes a test to fail, please explain why the change is appropriate.  Tests are code, just like the module itself, so it's very possbile that they need to be fixed as well.  Bonus points if you also write the fix for the test.
  * If implementing a brand-new function or behavior, please write a test for it.
* Please respect the formatting style of the rest of the module code as well.  If in doubt, place braces on a new line.

Changes will be merged to master and released when the module passes all Pester tests, including the module style tests.

## Contact

Feel free to comment on this project here on GitHub using the issues or discussion pages.  You can also check out [my blog](http://replicajunction.github.io/) or catch me on the [PowerShell subreddit](https://www.reddit.com/r/powershell).

*Note:* As with all community PowerShell modules and code, you use PSJira at your own risk.  I am not responsible if your JIRA instance causes a fire in your datacenter (literal or otherwise).
