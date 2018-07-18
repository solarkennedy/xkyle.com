build:
	hugo

serve:
	hugo serve

deploy: public
	cd public && git add --all && git commit -m "Publishing to gh-pages" && git push origin gh-pages

public:
	rm -rf public
	git worktree add -B gh-pages public origin/gh-pages
