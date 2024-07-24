# Cache false positive with label flag + transition

Bazel incorrectly fails to rebuild when a change is made to transition.bzl.

Repro steps:

1.  Initially, `hello_with_flag_set` depends on `other_library` via the label
    flag:

    ```
    $ bazelisk cquery 'somepath(//:hello_with_flag_set,//:other_library)'
    INFO: Analyzed 2 targets (86 packages loaded, 775 targets configured).
    INFO: Found 2 targets...
    //:hello_with_flag_set (8985b25)
    //:hello (c5ca09f)
    //:label_flag (c5ca09f)
    //:other_library (c5ca09f)
    ```

    This is expected, all is good.

2.  Change line 12 in transition.bzl from:

    ```
    "//:label_flag": "//:other_library",
    ```

    to:

    ```
    "//:label_flag": "//:empty_library",
    ```

    and run the same `bazelisk cquery`. You still get the same result! This is
    the bug!

3.  Run `bazelisk clean`. Now you (correctly) get,

    ```
    $ bazelisk cquery 'somepath(//:hello_with_flag_set,//:other_library)'
    INFO: Analyzed 2 targets (86 packages loaded, 404 targets configured).
    INFO: Found 2 targets...
    INFO: Empty query results
    ```
