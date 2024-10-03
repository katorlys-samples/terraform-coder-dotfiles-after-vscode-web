variable "agent_id" {
  type        = string
  description = "The ID of a Coder agent."
}

variable "default_dotfiles_uri" {
  type        = string
  description = "The default dotfiles URI if the workspace user does not provide one"
  default     = ""
}

variable "dotfiles_uri" {
  type        = string
  description = "The URL to a dotfiles repository. (optional, when set, the user isn't prompted for their dotfiles)"
  default     = null
}

variable "user" {
  type        = string
  description = "The name of the user to apply the dotfiles to. (optional, applies to the current user by default)"
  default     = null
}

variable "coder_parameter_order" {
  type        = number
  description = "The order determines the position of a template parameter in the UI/CLI presentation. The lowest order is shown first and parameters with equal order are sorted by name (ascending order)."
  default     = null
}

variable "manual_update" {
  type        = bool
  description = "If true, this adds a button to workspace page to refresh dotfiles on demand."
  default     = false
}

variable "port" {
  type        = number
  description = "The port to run VS Code Web on."
  default     = 13338
}

variable "vscode_display_name" {
  type        = string
  description = "The display name for the VS Code Web application."
  default     = "VS Code Web"
}

variable "vscode_slug" {
  type        = string
  description = "The slug for the VS Code Web application."
  default     = "vscode-web"
}

variable "folder" {
  type        = string
  description = "The folder to open in vscode-web."
  default     = ""
}

variable "share" {
  type    = string
  default = "owner"
  validation {
    condition     = var.share == "owner" || var.share == "authenticated" || var.share == "public"
    error_message = "Incorrect value. Please set either 'owner', 'authenticated', or 'public'."
  }
}

variable "log_path" {
  type        = string
  description = "The path to log."
  default     = "/tmp/vscode-web.log"
}

variable "install_prefix" {
  type        = string
  description = "The prefix to install vscode-web to."
  default     = "/tmp/vscode-web"
}

variable "extensions" {
  type        = list(string)
  description = "A list of extensions to install."
  default     = []
}

variable "accept_license" {
  type        = bool
  description = "Accept the VS Code Server license. https://code.visualstudio.com/license/server"
  default     = false
  validation {
    condition     = var.accept_license == true
    error_message = "You must accept the VS Code license agreement by setting accept_license=true."
  }
}

variable "telemetry_level" {
  type        = string
  description = "Set the telemetry level for VS Code Web."
  default     = "error"
  validation {
    condition     = var.telemetry_level == "off" || var.telemetry_level == "crash" || var.telemetry_level == "error" || var.telemetry_level == "all"
    error_message = "Incorrect value. Please set either 'off', 'crash', 'error', or 'all'."
  }
}

variable "order" {
  type        = number
  description = "The order determines the position of app in the UI presentation. The lowest order is shown first and apps with equal order are sorted by name (ascending order)."
  default     = null
}

variable "settings" {
  type        = map(string)
  description = "A map of settings to apply to VS Code web."
  default     = {}
}

variable "offline" {
  type        = bool
  description = "Just run VS Code Web in the background, don't fetch it from the internet."
  default     = false
}

variable "use_cached" {
  type        = bool
  description = "Uses cached copy of VS Code Web in the background, otherwise fetches it from internet."
  default     = false
}

variable "extensions_dir" {
  type        = string
  description = "Override the directory to store extensions in."
  default     = ""
}

variable "auto_install_extensions" {
  type        = bool
  description = "Automatically install recommended extensions when VS Code Web starts."
  default     = false
}