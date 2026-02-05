#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("https://gstreamer.freedesktop.org/src/orc/")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	links.reverse()
	version = None

	for link in links:
		href = link.get("href")
		if href and "tar.xz" in href:
			parts = href.rsplit("-", 1)
			version = parts[-1].rsplit(".", 2)[0]

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		final_name = f"orc-{version}.tar.xz"
		url = f"https://gstreamer.freedesktop.org/src/orc/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
