#! /bin/bash

set -ex

DEPLOY_REPO="https://${GITHUB_TOKEN}@github.com/liamg/liamg.github.io.git"
MESSAGE=$(git log -1 HEAD --pretty=format:%s)

function clean {
	echo "cleaning _site folder"
	if [ -d "_site" ]; then rm -Rf _site; fi
}

function clone_site {
	echo "getting latest site"
	git clone --depth 1 "${DEPLOY_REPO}" _site
}

function build {
	echo "building site"
	bundle exec jekyll build --lsi
}

function deploy {
	echo "deploying changes"

	if [ -z "$TRAVIS_PULL_REQUEST" ]; then
	    echo "except don't publish site for pull requests"
	    exit 0
	fi

	if [ "$TRAVIS_BRANCH" != "main" ]; then
	    echo "except we should only publish the master branch. stopping here"
	    exit 0
	fi

	cd _site
	git config user.name "Travis Build"
    git config user.email travis@liamg
	git add -A
	git commit -m "Travis Build: ${TRAVIS_BUILD_NUMBER}. ${MESSAGE}"
	git push "${DEPLOY_REPO}" master:master
}
