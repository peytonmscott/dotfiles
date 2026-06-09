-- Leader
vim.g.mapleader = " "

-- Core options
local opt = vim.opt
opt.confirm = true
opt.signcolumn = "yes:1"
opt.termguicolors = true
opt.ignorecase = true
opt.swapfile = false
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8
opt.inccommand = "nosplit"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.completeopt = { "menu", "menuone", "popup", "noinsert" }
opt.winborder = "rounded"
opt.hlsearch = false
opt.timeout = true
opt.timeoutlen = 500
vim.o.complete = ".,o"
vim.o.autocomplete = true
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)
vim.cmd.filetype("plugin indent on")

-- Core autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Core keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
    desc = "Open diagnostics float",
})

-- Plugin globals
vim.g.copilot_no_tab_map = true

-- Plugin install
vim.pack.add({
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-telescope/telescope-ui-select.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/ThePrimeagen/99",
    "https://github.com/folke/sidekick.nvim",
    "https://github.com/github/copilot.vim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/twenty9-labs/neotone.nvim",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/AlexandrosAlexiou/kotlin.nvim",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/folke/trouble.nvim",
    "https://github.com/stevearc/oil.nvim",
})

-- Built-in package extensions
vim.cmd.packadd("cfilter")
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- Telescope
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    telescope.setup({
        extensions = {
            ["ui-select"] = require("telescope.themes").get_dropdown(),
        },
    })
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
end

vim.keymap.set("n", "<leader>sf", ":Telescope find_files<cr>", {
    silent = true,
    desc = "Find files",
})

vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<cr>", {
    silent = true,
    desc = "Live grep",
})

vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<cr>", {
    silent = true,
    desc = "Search help tags",
})

vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics<cr>", {
    silent = true,
    desc = "Search diagnostics",
})

vim.keymap.set("n", "<leader>sb", ":Telescope buffers<cr>", {
    silent = true,
    desc = "Search buffers",
})

vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<cr>", {
    silent = true,
    desc = "Search keymaps",
})

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- 99
local nine_ok, nine_nine = pcall(require, "99")

if nine_ok then
    if type(nine_nine.setup) == "function" then
        nine_nine.setup()
    end

    vim.keymap.set("v", "<leader>9v", function()
        local visual_ok, err = pcall(function()
            nine_nine.visual()
        end)

        if not visual_ok then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end, {
        desc = "99 Visual",
    })

    vim.keymap.set("n", "<leader>9x", function()
        local stop_ok, err = pcall(function()
            nine_nine.stop_all_requests()
        end)

        if not stop_ok then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end, {

        desc = "99 Stop All Requests",

    })

    vim.keymap.set("n", "<leader>9s", function()
        local search_ok, err = pcall(function()
            nine_nine.search()
        end)

        if not search_ok then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end, {

        desc = "99 Search",

    })
end

-- Neotone
local neotone_ok, neotone = pcall(require, "neotone")
if neotone_ok then
    neotone.setup({
        mode = "system",
        themes = {
            dark = "catppuccin-mocha",
            light = "catppuccin-frappe",
        },
    })
end

-- Sidekick
local sidekick_ok, sidekick = pcall(require, "sidekick")
if sidekick_ok then
    sidekick.setup({
        nes = {
            enabled = false,
        },
        cli = {
            mux = {
                backend = "tmux",
                enabled = true,
            },
        },
    })

    vim.keymap.set({ "n", "t", "i", "x" }, "<C-.>", function()
        require("sidekick.cli").focus()
    end, {
        desc = "Sidekick Focus",
    })

    vim.keymap.set("n", "<leader>aa", function()
        require("sidekick.cli").toggle()
    end, {
        desc = "Sidekick Toggle CLI",
    })

    vim.keymap.set("n", "<leader>as", function()
        require("sidekick.cli").select()
    end, {
        desc = "Select CLI",
    })

    vim.keymap.set("n", "<leader>ad", function()
        require("sidekick.cli").close()
    end, {
        desc = "Detach a CLI Session",
    })

    vim.keymap.set({ "x", "n" }, "<leader>at", function()
        require("sidekick.cli").send({ msg = "{this}" })
    end, {
        desc = "Send This",
    })

    vim.keymap.set("n", "<leader>af", function()
        require("sidekick.cli").send({ msg = "{file}" })
    end, {
        desc = "Send File",
    })

    vim.keymap.set("x", "<leader>av", function()
        require("sidekick.cli").send({ msg = "{selection}" })
    end, {
        desc = "Send Visual Selection",
    })

    vim.keymap.set({ "n", "x" }, "<leader>ap", function()
        require("sidekick.cli").prompt()
    end, {
        desc = "Sidekick Select Prompt",
    })

    vim.keymap.set("n", "<leader>ac", function()
        require("sidekick.cli").toggle({
            name = "claude",
            focus = true,
        })
    end, {
        desc = "Sidekick Toggle Claude",
    })
end

-- Kotlin (disabled: kotlin-lsp build expired, waiting for JetBrains update)
-- local kotlin_ok, kotlin = pcall(require, "kotlin")
-- if kotlin_ok then
--     local brew_kotlin_lsp = "/opt/homebrew/opt/kotlin-lsp/libexec"
--     if not os.getenv("KOTLIN_LSP_DIR") and vim.fn.isdirectory(brew_kotlin_lsp) == 1 then
--         vim.env.KOTLIN_LSP_DIR = brew_kotlin_lsp
--     end
--
--     kotlin.setup({
--         root_markers = {
--             "gradlew",
--             "settings.gradle",
--             "settings.gradle.kts",
--             "build.gradle",
--             "build.gradle.kts",
--             "pom.xml",
--             ".git",
--         },
--         inlay_hints = {
--             enabled = true,
--         },
--         folding = {
--             enabled = true,
--         },
--         build_tool = "gradle",
--     })
--
--     vim.keymap.set("n", "<leader>ko", ":KotlinOrganizeImports<cr>", {
--         silent = true,
--         desc = "Kotlin organize imports",
--     })
--
--     vim.keymap.set("n", "<leader>kf", ":KotlinFormat<cr>", {
--         silent = true,
--         desc = "Kotlin format",
--     })
--
--     vim.keymap.set("n", "<leader>kh", ":KotlinInlayHintsToggle<cr>", {
--         silent = true,
--         desc = "Kotlin toggle inlay hints",
--     })
--
--     vim.keymap.set("n", "<leader>ks", ":KotlinSymbols<cr>", {
--         silent = true,
--         desc = "Kotlin document symbols",
--     })
--
--     vim.keymap.set("n", "<leader>kw", ":KotlinWorkspaceSymbols<cr>", {
--         silent = true,
--         desc = "Kotlin workspace symbols",
--     })
--
--     vim.keymap.set("n", "<leader>ka", ":KotlinCodeActions<cr>", {
--         silent = true,
--         desc = "Kotlin code actions",
--     })
--
--     vim.keymap.set("n", "<leader>kq", ":KotlinQuickFix<cr>", {
--         silent = true,
--         desc = "Kotlin quick fix",
--     })
--
--     vim.keymap.set("n", "<leader>kd", ":KotlinDebug<cr>", {
--         silent = true,
--         desc = "Kotlin debug attach",
--     })
-- end

-- Trouble
local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
    trouble.setup({})
end

-- DAP
local dap_ok, dap = pcall(require, "dap")
if dap_ok then
    vim.fn.sign_define("DapBreakpoint", {
        text = "B",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
        text = ">",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
    })

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {
        desc = "Debug breakpoint",
    })

    vim.keymap.set("n", "<leader>dc", dap.continue, {
        desc = "Debug continue",
    })

    vim.keymap.set("n", "<leader>dn", dap.step_over, {
        desc = "Debug step over",
    })

    vim.keymap.set("n", "<leader>di", dap.step_into, {
        desc = "Debug step into",
    })

    vim.keymap.set("n", "<leader>do", dap.step_out, {
        desc = "Debug step out",
    })

    vim.keymap.set("n", "<leader>dr", dap.repl.open, {
        desc = "Debug REPL",
    })

    vim.keymap.set("n", "<leader>dx", dap.terminate, {
        desc = "Debug terminate",
    })
end

-- Smart runner
local run_command_cache = {}

local function path_join(...)
    return table.concat({ ... }, "/")
end

local function file_exists(path)
    return vim.fn.filereadable(path) == 1
end

local function read_file(path)
    if not file_exists(path) then
        return ""
    end

    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return ""
    end

    return table.concat(lines, "\n")
end

local function buffer_path()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return vim.fn.getcwd()
    end
    return name
end

local function project_root()
    return vim.fs.root(buffer_path(), {
        "gradlew",
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        "pom.xml",
        "package.json",
        "Cargo.toml",
        "go.mod",
        ".git",
    }) or vim.fn.getcwd()
end

local function run_in_terminal(command, cwd)
    vim.cmd("botright 15new")
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.fn.termopen({ vim.o.shell, vim.o.shellcmdflag, command }, {
        cwd = cwd,
    })
    vim.cmd("startinsert")
end

local function system_text(argv, opts, callback)
    opts = opts or {}
    opts.text = true
    vim.system(argv, opts, function(result)
        vim.schedule(function()
            callback(result)
        end)
    end)
end

local function gradle_files(root)
    local files = {}
    vim.list_extend(files, vim.fn.globpath(root, "build.gradle", false, true))
    vim.list_extend(files, vim.fn.globpath(root, "build.gradle.kts", false, true))
    vim.list_extend(files, vim.fn.globpath(root, "*/build.gradle", false, true))
    vim.list_extend(files, vim.fn.globpath(root, "*/build.gradle.kts", false, true))
    return files
end

local function is_android_project(root)
    if not file_exists(path_join(root, "gradlew")) then
        return false
    end

    for _, file in ipairs(gradle_files(root)) do
        local content = read_file(file)
        if content:find("com.android.application", 1, true) then
            return true
        end
    end

    return false
end

local function parse_running_emulator(adb_devices_output)
    for line in adb_devices_output:gmatch("[^\r\n]+") do
        local serial, state = line:match("^(emulator%-%d+)%s+(%S+)")
        if serial and state == "device" then
            return serial
        end
    end
end

local function first_avd(list_output)
    for line in list_output:gmatch("[^\r\n]+") do
        line = vim.trim(line)
        if line ~= "" then
            return line
        end
    end
end

local function newest_file(paths)
    local newest
    local newest_time = -1
    for _, path in ipairs(paths) do
        local time = vim.fn.getftime(path)
        if time > newest_time then
            newest = path
            newest_time = time
        end
    end
    return newest
end

local function parse_apks(text)
    local apks = {}
    for apk in text:gmatch("[%w%._%+%/:%-]*%.apk") do
        if file_exists(apk) then
            table.insert(apks, apk)
        end
    end
    return apks
end

local function find_debug_apk(root, describe_output)
    local apks = parse_apks(describe_output or "")
    if #apks > 0 then
        return newest_file(apks)
    end

    local patterns = {
        "*/build/outputs/apk/debug/*.apk",
        "*/build/outputs/apk/*debug*/*.apk",
        "**/build/outputs/apk/debug/*.apk",
        "**/build/outputs/apk/*debug*/*.apk",
    }

    for _, pattern in ipairs(patterns) do
        apks = vim.fn.globpath(root, pattern, false, true)
        if #apks > 0 then
            return newest_file(apks)
        end
    end
end

local function deploy_android(root, serial, apk)
    vim.notify("Deploying " .. vim.fn.fnamemodify(apk, ":t") .. " to " .. serial, vim.log.levels.INFO)
    system_text({ "android", "run", "--device=" .. serial, "--apks=" .. apk }, {
        cwd = root,
    }, function(result)
        if result.code ~= 0 then
            vim.notify((result.stderr ~= "" and result.stderr or result.stdout), vim.log.levels.ERROR)
            return
        end

        vim.notify("Android app launched", vim.log.levels.INFO)
    end)
end

local function with_android_device(callback)
    system_text({ "adb", "devices" }, {}, function(adb_result)
        local serial = parse_running_emulator(adb_result.stdout or "")
        if serial then
            callback(serial)
            return
        end

        system_text({ "android", "emulator", "list" }, {}, function(list_result)
            if list_result.code ~= 0 then
                vim.notify((list_result.stderr ~= "" and list_result.stderr or list_result.stdout), vim.log.levels.ERROR)
                return
            end

            local avd = first_avd(list_result.stdout or "")
            if not avd then
                vim.notify("No Android emulator found", vim.log.levels.ERROR)
                return
            end

            vim.notify("Starting emulator " .. avd, vim.log.levels.INFO)
            system_text({ "android", "emulator", "start", avd }, {}, function(start_result)
                if start_result.code ~= 0 then
                    vim.notify((start_result.stderr ~= "" and start_result.stderr or start_result.stdout), vim.log.levels.ERROR)
                    return
                end

                system_text({ "adb", "devices" }, {}, function(after_start_result)
                    serial = parse_running_emulator(after_start_result.stdout or "")
                    if not serial then
                        vim.notify("Emulator started, but adb did not report a ready emulator", vim.log.levels.ERROR)
                        return
                    end

                    callback(serial)
                end)
            end)
        end)
    end)
end

local function run_android_project(root)
    local gradlew = path_join(root, "gradlew")
    local build_cmd = file_exists(gradlew) and "./gradlew assembleDebug" or "gradle assembleDebug"

    vim.notify("Building Android app", vim.log.levels.INFO)
    system_text({ vim.o.shell, vim.o.shellcmdflag, build_cmd }, {
        cwd = root,
    }, function(build_result)
        if build_result.code ~= 0 then
            run_in_terminal(build_cmd, root)
            vim.notify("Android build failed; opened build command in a terminal", vim.log.levels.ERROR)
            return
        end

        system_text({ "android", "describe", "--project_dir=" .. root }, {
            cwd = root,
        }, function(describe_result)
            local apk = find_debug_apk(root, (describe_result.stdout or "") .. "\n" .. (describe_result.stderr or ""))
            if not apk then
                vim.notify("Could not find a debug APK after build", vim.log.levels.ERROR)
                return
            end

            with_android_device(function(serial)
                deploy_android(root, serial, apk)
            end)
        end)
    end)
end

local function package_script(root)
    local package_json = path_join(root, "package.json")
    if not file_exists(package_json) then
        return nil
    end

    local ok, decoded = pcall(vim.json.decode, read_file(package_json))
    if not ok or type(decoded) ~= "table" or type(decoded.scripts) ~= "table" then
        return nil
    end

    for _, script in ipairs({ "dev", "start", "test" }) do
        if decoded.scripts[script] then
            return "npm run " .. script
        end
    end
end

local function file_runner()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        return nil
    end

    local escaped_file = vim.fn.shellescape(file)
    local ft = vim.bo.filetype
    local runners = {
        lua = "lua " .. escaped_file,
        python = "python3 " .. escaped_file,
        javascript = "node " .. escaped_file,
        sh = "bash " .. escaped_file,
        go = "go run " .. escaped_file,
    }

    if ft == "typescript" then
        return vim.fn.executable("tsx") == 1 and "tsx " .. escaped_file or nil
    end

    return runners[ft]
end

local function command_for_root(root)
    if file_exists(path_join(root, "package.json")) then
        local script = package_script(root)
        if script then
            return script
        end
    end

    if file_exists(path_join(root, "Cargo.toml")) then
        return "cargo run"
    end

    if file_exists(path_join(root, "go.mod")) then
        return "go run ./..."
    end

    if file_exists(path_join(root, "gradlew")) then
        local gradle_text = ""
        for _, file in ipairs(gradle_files(root)) do
            gradle_text = gradle_text .. "\n" .. read_file(file)
        end

        if gradle_text:find("application", 1, true) then
            return "./gradlew run"
        end

        return "./gradlew build"
    end

    if file_exists(path_join(root, "pom.xml")) then
        local pom = read_file(path_join(root, "pom.xml"))
        if pom:find("spring%-boot", 1, false) then
            return file_exists(path_join(root, "mvnw")) and "./mvnw spring-boot:run" or "mvn spring-boot:run"
        end

        return file_exists(path_join(root, "mvnw")) and "./mvnw test" or "mvn test"
    end

    return file_runner()
end

local function smart_run()
    local root = project_root()

    if is_android_project(root) then
        run_android_project(root)
        return
    end

    local command = run_command_cache[root] or command_for_root(root)
    if command then
        run_command_cache[root] = command
        run_in_terminal(command, root)
        return
    end

    vim.ui.input({
        prompt = "Run command: ",
    }, function(input)
        if not input or vim.trim(input) == "" then
            return
        end

        run_command_cache[root] = input
        run_in_terminal(input, root)
    end)
end

vim.keymap.set("n", "<leader>r", smart_run, {
    desc = "Run project or file",
})

-- LSP
vim.lsp.enable({
    "copilot-language-server",
    "roslyn",
    "lua_ls",
    "basedpyright",
    "marksman",
    "yamlls",
    "terraformls",
    "ts_ls",
    "jsonls",
})

local function format_buffer(bufnr)
    vim.lsp.buf.format({
        async = false,
        timeout_ms = 3000,
        bufnr = bufnr,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {

    callback = function(args)
        vim.o.signcolumn = "yes:1"

        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
    end,

})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        local clients = vim.lsp.get_clients({
            bufnr = args.buf,
            method = "textDocument/formatting",
        })
        if #clients == 0 then
            return
        end
        format_buffer(args.buf)
    end,
})

vim.keymap.set("n", "<leader>f", function()
    format_buffer(0)
end, {
    silent = true,
    desc = "Format file",
})

-- Completion
vim.keymap.set("i", "<Down>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.keycode("<C-n>")
    end
    return vim.keycode("<Down>")
end, {
    expr = true,
    silent = true,
    desc = "Next completion item or move cursor down",
})

vim.keymap.set("i", "<Up>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.keycode("<C-p>")
    end
    return vim.keycode("<Up>")
end, {
    expr = true,
    silent = true,
    desc = "Previous completion item or move cursor up",
})

vim.keymap.set("i", "<Tab>", 'pumvisible() == 1 ? "\\<C-y>" : copilot#Accept("\\<Tab>")', {
    expr = true,
    silent = true,
    replace_keycodes = false,
    desc = "Accept completion, accept Copilot, or insert tab",
})

vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.keycode("<C-e><CR>")
    end
    return vim.keycode("<CR>")
end, {
    expr = true,
    silent = true,
    desc = "Newline without accepting completion",
})

-- Which-key
local which_key_ok, which_key = pcall(require, "which-key")
if which_key_ok then
    which_key.setup({})
    which_key.add({
        { "<leader>9", group = "99" },
        { "<leader>a", group = "agent" },
        { "<leader>d", group = "debug" },
        -- { "<leader>k", group = "kotlin" },
        { "<leader>s", group = "search" },
    })
end

-- Appearence change listener
vim.cmd [[
  if empty(v:servername)
    call serverstart('/tmp/nvim.sock')
  endif
]]
