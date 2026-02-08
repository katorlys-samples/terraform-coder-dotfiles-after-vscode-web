terraform {
  required_version = ">= 1.0"

  required_providers {
    coder = {
      source  = "coder/coder"
      version = ">= 2.5"
    }
  }
}

data "coder_workspace_owner" "me" {}
data "coder_workspace" "me" {}

resource "coder_script" "dotfiles-after-vscode-web" {
  agent_id     = var.agent_id
  display_name = "VS Code Web"
  icon         = "/icon/code.svg"
  script = templatefile("${path.module}/run.sh", {
    PORT : var.port,
    LOG_PATH : var.log_path,
    INSTALL_PREFIX : var.install_prefix,
    EXTENSIONS : join(",", var.extensions),
    TELEMETRY_LEVEL : var.telemetry_level,
    SETTINGS : replace(jsonencode(var.settings), "\"", "\\\""),
    OFFLINE : var.offline,
    USE_CACHED : var.use_cached,
    DISABLE_TRUST : var.disable_trust,
    EXTENSIONS_DIR : var.extensions_dir,
    FOLDER : var.folder,
    WORKSPACE : var.workspace,
    AUTO_INSTALL_EXTENSIONS : var.auto_install_extensions,
    SERVER_BASE_PATH : local.server_base_path,
    COMMIT_ID : var.commit_id,
    PLATFORM : var.platform,
    DOTFILES_URI : local.dotfiles_uri,
    DOTFILES_USER : local.user
  })
  run_on_start = true

  lifecycle {
    precondition {
      condition     = !var.offline || length(var.extensions) == 0
      error_message = "Offline mode does not allow extensions to be installed"
    }

    precondition {
      condition     = !var.offline || !var.use_cached
      error_message = "Offline and Use Cached can not be used together"
    }

    precondition {
      condition     = (var.workspace == "" || var.folder == "")
      error_message = "Set only one of `workspace` or `folder`."
    }
  }
}

resource "coder_app" "vscode-web" {
  agent_id     = var.agent_id
  slug         = var.slug
  display_name = var.display_name
  url          = local.url
  icon         = "/icon/code.svg"
  subdomain    = var.subdomain
  share        = var.share
  order        = var.order
  group        = var.group

  healthcheck {
    url       = local.healthcheck_url
    interval  = 5
    threshold = 6
  }
}

data "coder_parameter" "dotfiles_uri" {
  count        = var.dotfiles_uri == null ? 1 : 0
  type         = "string"
  name         = "dotfiles_uri"
  display_name = "Dotfiles URL"
  order        = var.coder_parameter_order
  default      = var.default_dotfiles_uri
  description  = var.dotfiles_description
  mutable      = true
  icon         = "/icon/dotfiles.svg"
}

locals {
  dotfiles_uri     = var.dotfiles_uri != null ? var.dotfiles_uri : data.coder_parameter.dotfiles_uri[0].value
  user             = var.user != null ? var.user : ""
  server_base_path = var.subdomain ? "" : format("/@%s/%s/apps/%s/", data.coder_workspace_owner.me.name, data.coder_workspace.me.name, var.slug)
  url = (
    var.workspace != "" ?
    "http://localhost:${var.port}${local.server_base_path}?workspace=${urlencode(var.workspace)}" :
    var.folder != "" ?
    "http://localhost:${var.port}${local.server_base_path}?folder=${urlencode(var.folder)}" :
    "http://localhost:${var.port}${local.server_base_path}"
  )
  healthcheck_url = var.subdomain ? "http://localhost:${var.port}/healthz" : "http://localhost:${var.port}${local.server_base_path}/healthz"
}

# resource "coder_script" "dotfiles" {
#   agent_id = var.agent_id
#   script = templatefile("${path.module}/dotfiles_run.sh", {
#     DOTFILES_URI : local.dotfiles_uri,
#     DOTFILES_USER : local.user
#   })
#   display_name = "Dotfiles"
#   icon         = "/icon/dotfiles.svg"
#   run_on_start = true
#   depends_on = [ coder_script.vscode-web ]
# }

resource "coder_app" "dotfiles" {
  count        = var.manual_update ? 1 : 0
  agent_id     = var.agent_id
  display_name = "Refresh Dotfiles"
  slug         = "dotfiles"
  icon         = "/icon/dotfiles.svg"
  order        = var.order
  group        = var.group
  command = templatefile("${path.module}/dotfiles_run.sh", {
    DOTFILES_URI : local.dotfiles_uri,
    DOTFILES_USER : local.user
  })
}