return {
    activate_mark_hook                            = "activate-mark-hook",
    deactivate_mark_hook                          = "deactivate-mark-hook",

    -- See The Mark.
    after_change_functions                        = "after-change-functions",
    before_change_functions                       = "before-change-functions",
    first_change_hook                             = "first-change-hook",

    -- See Change Hooks.
    after_change_major_mode_hook                  = "after-change-major-mode-hook",
    change_major_mode_after_body_hook             = "change-major-mode-after-body-hook",

    -- See Mode Hooks.
    after_init_hook                               = "after-init-hook",
    before_init_hook                              = "before-init-hook",
    emacs_startup_hook                            = "emacs-startup-hook",
    window_setup_hook                             = "window-setup-hook",

    -- See The Init File.
    after_insert_file_functions                   = "after-insert-file-functions",
    write_region_annotate_functions               = "write-region-annotate-functions",
    write_region_post_annotation_function         = "write-region-post-annotation-function",

    -- See File Format Conversion.
    after_make_frame_functions                    = "after-make-frame-functions",
    before_make_frame_hook                        = "before-make-frame-hook",
    server_after_make_frame_hook                  = "server-after-make-frame-hook",

    -- See Creating Frames.
    after_save_hook                               = "after-save-hook",
    before_save_hook                              = "before-save-hook",
    write_contents_functions                      = "write-contents-functions",
    write_file_functions                          = "write-file-functions",

    -- See Saving Buffers.
    after_setting_font_hook                       = "after-setting-font-hook",

    -- Hook run after a frame’s font changes.
    auto_save_hook                                = "auto-save-hook",

    -- See Auto-Saving.
    before_hack_local_variables_hook              = "before-hack-local-variables-hook",
    hack_local_variables_hook                     = "hack-local-variables-hook",

    -- See File Local Variables.
    buffer_access_fontify_functions               = "buffer-access-fontify-functions",

    -- See Lazy Computation of Text Properties.
    buffer_list_update_hook                       = "buffer-list-update-hook ",

    -- Hook run when the buffer list changes (see The Buffer List).
    buffer_quit_function                          = "buffer-quit-function",

    -- Function to call to quit the current buffer.
    change_major_mode_hook                        = "change-major-mode-hook",

    -- See Creating and Deleting Buffer-Local Bindings.
    comint_password_function                      = "comint-password-function",

    -- This abnormal hook permits a derived mode to supply a password for the underlying command interpreter without prompting the user.
    command_line_functions                        = "command-line-functions",

    -- See Command-Line Arguments.
    delayed_warnings_hook                         = "delayed-warnings-hook",

    -- The command loop runs this soon after post-command-hook (q.v.).
    focus_in_hook                                 = "focus-in-hook",
    focus_out_hook                                = "focus-out-hook",

    -- See Input Focus.
    delete_frame_functions                        = "delete-frame-functions",
    after_delete_frame_functions                  = "after-delete-frame-functions",

    -- See Deleting Frames.
    delete_terminal_functions                     = "delete-terminal-functions",

    -- See Multiple Terminals.
    pop_up_frame_function                         = "pop-up-frame-function",
    split_window_preferred_function               = "split-window-preferred-function",

    -- See Additional Options for Displaying Buffers.
    echo_area_clear_hook                          = "echo-area-clear-hook",

    -- See Echo Area Customization.
    find_file_hook                                = "find-file-hook",
    find_file_not_found_functions                 = "find-file-not-found-functions",

    -- See Functions for Visiting Files.
    font_lock_extend_after_change_region_function = "font-lock-extend-after-change-region-function",

    -- See Region to Fontify after a Buffer Change.
    font_lock_extend_region_functions             = "font-lock-extend-region-functions",

    -- See Multiline Font Lock Constructs.
    font_lock_fontify_buffer_function             = "font-lock-fontify-buffer-function",
    font_lock_fontify_region_function             = "font-lock-fontify-region-function",
    font_lock_mark_block_function                 = "font-lock-mark-block-function",
    font_lock_unfontify_buffer_function           = "font-lock-unfontify-buffer-function",
    font_lock_unfontify_region_function           = "font-lock-unfontify-region-function",

    -- See Other Font Lock Variables.
    fontification_functions                       = "fontification-functions",

    -- See Automatic Face Assignment.
    frame_auto_hide_function                      = "frame-auto-hide-function",

    -- See Quitting Windows.
    quit_window_hook                              = "quit-window-hook",

    -- See Quitting Windows.
    kill_buffer_hook                              = "kill-buffer-hook",
    kill_buffer_query_functions                   = "kill-buffer-query-functions",

    -- See Killing Buffers.
    kill_emacs_hook                               = "kill-emacs-hook",
    kill_emacs_query_functions                    = "kill-emacs-query-functions",

    -- See Killing Emacs.
    menu_bar_update_hook                          = "menu-bar-update-hook",

    -- See The Menu Bar.
    minibuffer_setup_hook                         = "minibuffer-setup-hook",
    minibuffer_exit_hook                          = "minibuffer-exit-hook",

    -- See Minibuffer Miscellany.
    mouse_leave_buffer_hook                       = "mouse-leave-buffer-hook",

    -- Hook run when the user mouse-clicks in a window.
    mouse_position_function                       = "mouse-position-function",

    -- See Mouse Position.
    prefix_command_echo_keystrokes_functions      = "prefix-command-echo-keystrokes-functions",

    --- An abnormal hook run by prefix commands (such as C-u) which should return a string describing the current prefix state. For example", C-u produces ‘C-u-’ and ‘C-u 1 2 3-’. Each hook function is called with no arguments and should return a string describing the current prefix state", or nil if there’s no prefix state. See Prefix Command Arguments.
    prefix_command_preserve_state_hook            = "prefix-command-preserve-state-hook",

    -- Hook run when a prefix command needs to preserve the prefix by passing the current prefix command state to the next command. For example", C-u needs to pass the state to the next command when the user types C-u - or follows C-u with a digit.
    pre_redisplay_functions                       = "pre-redisplay-functions",

    -- Hook run in each window just before redisplaying it. See Forcing Redisplay.
    post_command_hook                             = "post-command-hook",
    pre_command_hook                              = "pre-command-hook",

    -- See Command Loop Overview.
    post_gc_hook                                  = "post-gc-hook",

    -- See Garbage Collection.
    post_self_insert_hook                         = "post-self-insert-hook",

    -- See Keymaps and Minor Modes.
    suspend_hook                                  = "suspend-hook",
    suspend_resume_hook                           = "suspend-resume-hook",
    suspend_tty_functions                         = "suspend-tty-functions",
    resume_tty_functions                          = "resume-tty-functions",

    -- See Suspending Emacs.
    syntax_begin_function                         = "syntax-begin-function",
    syntax_propertize_extend_region_functions     = "syntax-propertize-extend-region-functions",
    syntax_propertize_function                    = "syntax-propertize-function",
    font_lock_syntactic_face_function             = "font-lock-syntactic-face-function",

    -- See Syntactic Font Lock. See Syntax Properties.
    temp_buffer_setup_hook                        = "temp-buffer-setup-hook",
    temp_buffer_show_function                     = "temp-buffer-show-function",
    temp_buffer_show_hook                         = "temp-buffer-show-hook",

    -- See Temporary Displays.
    tty_setup_hook                                = "tty-setup-hook",

    -- See Terminal-Specific Initialization.
    window_configuration_change_hook              = "window-configuration-change-hook",
    window_scroll_functions                       = "window-scroll-functions",
    window_size_change_functions                  = "window-size-change-functions",

}
