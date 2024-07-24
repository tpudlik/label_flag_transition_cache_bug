def _transition_impl(settings, attr):
    # buildifier: disable=unused-variable
    _ignore = settings, attr
    return {
        # The next line is the one to change, see README.
        "//:label_flag": "//:other_library",
    }

_transition = transition(
    implementation = _transition_impl,
    inputs = [],
    outputs = ["//:label_flag"],
)

def _binary_with_flag_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(output = out, is_executable = True, target_file = ctx.executable.binary)
    return [DefaultInfo(files = depset([out]), executable = out)]

binary_with_flag = rule(
    _binary_with_flag_impl,
    attrs = {
        "binary": attr.label(
            doc = "cc_binary build with the flag set",
            cfg = _transition,
            executable = True,
            mandatory = True,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    doc = "Builds the specified binary with the flag set",
    executable = False,
)
