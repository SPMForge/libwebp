# Tests

This directory contains repo-local tests for the libwebp packaging wrapper.
The default branch does not keep upstream source tests or fuzzing targets.

## Python Tests

- `test_spm_release.py`: unit tests for release planning, artifact naming,
  package rendering, and workflow contracts.

Run the test suite with:

```shell
$ python3 -m unittest tests/test_spm_release.py
```
