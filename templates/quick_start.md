## Quick Start
{% set short_repository = repository.split("/")[1] -%}

### Full

To pull the latest slim version:

```bash
docker pull ghcr.io/{{ organization  }}/{{ short_repository }}:py{{ python_versions|last }}-LATEST
```

To include it in the dockerfile instead:

```dockerfile
FROM ghcr.io/{{ organization  }}/{{ short_repository }}:py{{ python_versions|last }}-LATEST
```

### Slim

To pull the latest slim version:

```bash
docker pull ghcr.io/{{ organization  }}/{{ short_repository }}:py{{ python_versions|last }}-slim-LATEST
```

To include it in the dockerfile instead:

```dockerfile
FROM ghcr.io/{{ organization  }}/{{ short_repository }}:py{{ python_versions|last }}-slim-LATEST
```

### Copy Just the Packages

It's also possible to copy just the Python packages themselves. This is particularly useful when you want to use the precompiled libraries from multiple containers.

```dockerfile
FROM python:{{ python_versions|last }}

COPY --from=ghcr.io/{{ organization  }}/{{ short_repository }}:py{{ python_versions|last }}-slim-LATEST /usr/local/lib/python{{ python_versions|last }}/site-packages/* /usr/local/lib/python{{ python_versions|last }}/site-packages/
COPY --from=ghcr.io/{{ organization  }}/{{ short_repository }}:py{{ python_versions|last }}-slim-LATEST /opt/oso /opt/oso
```
