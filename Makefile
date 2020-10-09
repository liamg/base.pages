.PHONY: initpost clean clone_site build deploy

initpost:
	@bash -c "./scripts/initpost.sh"

clean:
	@bash -c ". scripts/build.sh && clean"

clone_site:
	@bash -c ". scripts/build.sh && clone_site"

build: clean clone_site
	@bash -c ". scripts/build.sh && build"

serve:
	@bash -c "bundle install && bundle exec jekyll serve --livereload"

deploy: build
	@bash -c ". scripts/build.sh && deploy"
