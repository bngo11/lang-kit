#!/usr/bin/python3
from bs4 import BeautifulSoup

GLOBAL_DEFAULTS = {}

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("https://go.dev/dl/")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	version = None

	for link in links:
		href = link.get("href")
		if href and href.endswith("linux-amd64.tar.gz"):
			parts = href.split("/")
			version = parts[-1].rsplit(".", 3)[0].lstrip('go')

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		url = f"https://go.dev/dl/go{version}.src.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
