# Maintainer: ExistingPerson08
pkgname=spacefin-cli-git
pkgver=r1.743ac31
pkgrel=1
pkgdesc="Spacefin cli and Spacefin welcome screen"
arch=('any')
url="https://github.com/ExistingPerson08/Spacefin-cli"
license=('MIT')
depends=('bash')
makedepends=('git')
provides=("${pkgname%-git}")
conflicts=("${pkgname%-git}")
source=("${pkgname}::git+${url}.git")
sha256sums=('SKIP')

pkgver() {
  cd "$pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "$pkgname"

  install -d "$pkgdir/usr/bin"

  install -m755 spacefin-cli "$pkgdir/usr/bin/spacefin-cli"
  install -m755 spacefin-welcome "$pkgdir/usr/bin/spacefin-welcome"
}
