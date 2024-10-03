<a name="readme-top"></a>
<div align="center">

<!-- <a href="#">
  <img src="https://github.com/katorlys/.github/blob/main/assets/mark/mark.png" height="100">
</a><br> -->

<h1>
  Coder Dotfiles after VS Code Module
</h1>

<p>
  Terraform Module to install dotfiles after vscode-web installation in Coderv2.
</p>

[![Pull Requests][github-pr-badge]][github-pr-link]
[![Issues][github-issue-badge]][github-issue-link]
[![License][github-license-badge]](LICENSE)

</div>


<!-- Main Body -->

## Introduction
This module is copied from [Coder VS Code Web Module](https://registry.coder.com/modules/vscode-web) and [Coder Dotfiles Module](https://registry.coder.com/modules/dotfiles) (Both licensed under [Apache License 2.0](https://github.com/coder/modules/blob/438c9045673c629e95416960c94a6b6344e3d298/LICENSE)), and adds the feature of executing the dotfiles install script after VS Code web installation.

This is a temporary fix for issue [https://github.com/coder/coder/issues](https://github.com/coder/coder/issues)#10352.

By using this module, you don't need to use the Coder VS Code Web Module and Coder Dotfiles Module anymore, and you'll never see `/tmp/vscode-web/bin/code-server: 12: /tmp/vscode-web/node: Text file busy` if you want to install VS Code installation in Coderv2 from your dotfiles now.


## Examples
Combine [Coder VS Code Web Module](https://registry.coder.com/modules/vscode-web?tab=readme) and [Coder Dotfiles Module](https://registry.coder.com/modules/dotfiles?tab=readme) together.
```tf
module "dotfiles-after-vscode-web" {
  source         = "katorlys-samples/dotfiles-after-vscode-web/coder"
  version        = "0.1.0"
  agent_id       = coder_agent.example.id
  folder         = "/home/coder"
  accept_license = true
}
```


## How?
This modules combines the Coder VS Code Web Module and Coder Dotfiles Module together in one module. Then, it executes the original dotfiles install script right after VS Code web install script is done. (See [run.sh](/run.sh) for detailed information)


## Why?
I initially intended to fix the issue privately. However, the shell scripts on Windows use `\r\n` for End of Line instead of `\n`, and Coder cannot automatically convert them, causing script execution to fail.

Since I deploy the Coder instance using Docker, I can only copy the script to the online editor. Additionally, the `Upload template` function is broken, preventing me from packaging and uploading the scripts.

All attempts failed, so I had no choice but to publish a module from Git to avoid the End of Line issue.


<!-- /Main Body -->


<div align="right">
  
[![BACK TO TOP][back-to-top-button]](#readme-top)

</div>

---

<div align="center">

<p>
  Copyright &copy; 2024-present <a target="_blank" href="https://github.com/katorlys">Katorly Lab</a>
</p>

[![License][github-license-badge-bottom]](LICENSE)

</div>

[back-to-top-button]: https://img.shields.io/badge/BACK_TO_TOP-151515?style=flat-square
[github-pr-badge]: https://img.shields.io/github/issues-pr/katorlys-samples/terraform-coder-dotfiles-after-vscode-web?label=pulls&labelColor=151515&color=79E096&style=flat-square
[github-pr-link]: https://github.com/katorlys-samples/terraform-coder-dotfiles-after-vscode-web/pulls
[github-issue-badge]: https://img.shields.io/github/issues/katorlys-samples/terraform-coder-dotfiles-after-vscode-web?labelColor=151515&color=FFC868&style=flat-square
[github-issue-link]: https://github.com/katorlys-samples/terraform-coder-dotfiles-after-vscode-web/issues
[github-license-badge]: https://img.shields.io/github/license/katorlys-samples/terraform-coder-dotfiles-after-vscode-web?labelColor=151515&color=EFEFEF&style=flat-square
<!-- https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-EFEFEF?labelColor=151515&style=flat-square -->
[github-license-badge-bottom]: https://img.shields.io/github/license/katorlys-samples/terraform-coder-dotfiles-after-vscode-web?labelColor=151515&color=EFEFEF&style=for-the-badge
<!-- https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-EFEFEF?labelColor=151515&style=for-the-badge -->