# https://docs.ansible.com/ansible/latest/dev_guide/developing_locally.html
# https://dev.to/aaronktberry/creating-custom-ansible-filters-29kf
# https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/filter/core.py
# https://github.com/ansible/ansible/blob/devel/lib/ansible/parsing/yaml/dumper.py

from ansible.parsing.yaml.objects import AnsibleUnicode
from toml import encoder


class TomlAnsibleEncoder(encoder.TomlEncoder):

    def __init__(self, _dict=dict, preserve=False):
        super(TomlAnsibleEncoder, self).__init__(_dict, preserve)
        self.dump_funcs[AnsibleUnicode] = encoder._dump_str
        # self.dump_funcs[AnsibleSequence] = self.dump_list
        # self.dump_funcs[AnsibleMapping] = self.dump_sections


def to_toml(a):
    """ Convert the value to TOML """
    return encoder.dumps(a, encoder=TomlAnsibleEncoder())


def to_apt(r):
    source = r.get("source", False)

    options = r.get("options")
    if (options is not None) and (not isinstance(options, dict)):
        raise ValueError(f"options should be a dict, got {type(options)}")

    if "uri" not in r:
        raise ValueError("uri is required")
    uri = r["uri"]

    if "distribution" not in r:
        raise ValueError("distribution is required")
    distribution = r["distribution"]

    components = r.get("components")
    if isinstance(components, str):
        components = [components]
    elif not isinstance(components, (list, tuple)):
        raise ValueError(f"components should be a string or a collection, got {type(components)}")

    result = "deb-src" if source else "deb"
    if options:
        opts = ",".join([f"{k}={v}" for k, v in options.items()])
        result = f"{result} [{opts}]"
    result = f"{result} {uri} {distribution}"
    if components:
        comps = " ".join(components)
        result = f"{result} {comps}"

    return result


class FilterModule(object):
    def filters(self):
        return {
            "to_toml": to_toml,
            "to_apt": to_apt
        }
