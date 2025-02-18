#!/sr/bin/env python3

import requests

async def generate(hub, **pkginfo):
	# json_data = await hub.pkgtools.fetch.get_page(f"https://ziglang.org/download/index.json", is_json=True)
	result = requests.get("https://ziglang.org/download/index.json")
	json_data = result.json()
	versions = list(json_data.keys())
	versions.remove('master')

	for version in versions:
		try:
			verlist = version.split('.')
			list(map(int, verlist))
			break

		except (KeyError, IndexError, ValueError):
			continue

	data = json_data.get(version)
	ebuilds_to_generate = [('dev-lang/zig', 'src'), ('dev-lang/zig-bin', 'x86_64-linux'), ('virtual/zig', 'src'),]

	for catpkg, key in ebuilds_to_generate:
		cat, pkg = catpkg.split('/')

		if cat == 'virtual': template = cat
		else: template = pkg

		template = template + '.tmpl'

		pkginfo['name'] = pkg
		pkginfo['cat']  = cat
		if template:
			pkginfo['template'] = template

		if pkg.endswith("-bin"):
			architecture_names = dict(
				x86_64='amd64',
				x86='x86',
				riscv64='riscv64',
				aarch64='arm64',
				armv7a='arm',
			)
			artifact = {}
			for k, v in architecture_names.items():
				url = data[f"{k}-linux"]['tarball']
				artifact[v] = hub.pkgtools.ebuild.Artifact(url=url, final_name=url.split("/")[-1])
		else:
			url = data[key]['tarball']
			artifact = [hub.pkgtools.ebuild.Artifact(url=url, final_name=url.split("/")[-1])]

		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			dev=False,
			artifacts=artifact
		)
		ebuild.push()

# vim: ts=4 sw=4 noet
