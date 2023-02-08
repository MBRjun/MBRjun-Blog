nodeversion=$(shell node -v | cut -c2-3)
nodepm=npm
SHELL=/bin/bash
#nodepm=yarn

.PHONY: world check genver init git modify submodules-build submodules-scripts submodules packages hexo cimod ci clean substash

world: hexo

check:
	@if [ -z $(nodeversion) ]; then\
		echo -e "\033[41;37m[CHECK  ]\033[0m Node.js was not detected.\n\033[32m[CHECK  ]\033[0m Install Node.js v18 or v19 first." && exit 2;\
	elif [ $(nodeversion) = "18" ]; then\
		echo -e "\033[32m[CHECK  ]\033[0m Node.js 18($(shell node -v)) detected";\
	elif [ $(nodeversion) = "19" ]; then\
		echo -e "\033[32m[CHECK  ]\033[0m Node.js 19($(shell node -v)) detected.";\
	else\
		echo -e "\033[41;37m[CHECK  ]\033[0m Unsupported Node.js version detected.\n\033[32m[CHECK  ]\033[0m You are using $(shell node -v) but the program requires v18 or v19.\n\033[32m[CHECK  ]\033[0m Upgrade/Downgrade Node.js to v18/v19, or use nvm to select version." && exit 2;\
	fi

genver: git
	@echo -e "\033[32m[GENVER ]\033[0m Generating build info...\c"
	@cp modify/genver.default modify/genver
	@sed -i 's/HEAD/$(shell git rev-parse HEAD)/g' modify/genver
	@sed -i 's/user/$(shell whoami)/g' modify/genver
	@sed -i 's/host/$(shell hostnamectl hostname)/g' modify/genver
	@sed -i 's/kver/$(shell uname -r)/g' modify/genver
	@sed -i 's/cn-date/$(shell TZ=Asia/Hong_Kong date "+%Y-%m-%d")/g' modify/genver
	@echo -e "ok"

init: check
	@echo -e "\033[32m[GIT    ]\033[0m Updating submodules... " && git submodule update --init --recursive

git: init
	@if [ $(shell git rev-parse --abbrev-ref HEAD) = "main" ]; then\
		echo -e "\033[32m[GIT    ]\033[0m \c" && git pull --ff-only;\
	else\
		echo -e "\033[32m[GIT    ]\033[0m Not using branch main. Skip.";\
	fi

modify: git substash
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/_config.yml" && cp modify/theme.yml themes/tranquilpeak/_config.yml
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/languages/zh-cn.yml" && cp modify/zh-cn.yml themes/tranquilpeak/languages/zh-cn.yml
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/layout/_partial/footer.ejs" && cp modify/footer.ejs themes/tranquilpeak/layout/_partial/footer.ejs
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/layout/_partial/post.ejs" && cp modify/post.ejs themes/tranquilpeak/layout/_partial/post.ejs

submodules-build: packages modify
	@echo -e "\033[32m[PACKAGE]\033[0m submodules: $(nodepm) run grunt -- buildProd" && cd themes/tranquilpeak/ && $(nodepm) run grunt -- buildProd

submodules-scripts: submodules-build genver
	@echo -e "\033[32m[GENVER ]\033[0m Writing build info and query string into source...\c"
	@sed -i '186c <script async defer src="/assets/js/script.min.js?v=$(shell git rev-parse HEAD)"></script>' themes/tranquilpeak/layout/_partial/head.ejs
	@sed -i '183c <link rel="stylesheet" href="/assets/css/style.min.css?v=$(shell git rev-parse HEAD)">' themes/tranquilpeak/layout/_partial/head.ejs
	@cat modify/genver >> themes/tranquilpeak/layout/_partial/script.ejs
	@echo -e "ok"
	@cat modify/genver

submodules: submodules-scripts

packages: init
	@echo -e "\033[32m[PACKAGE]\033[0m MBRjun-Blog: $(nodepm) install" && $(nodepm) install
	@echo -e "\033[32m[PACKAGE]\033[0m submodules: $(nodepm) install" && cd themes/tranquilpeak/ && $(nodepm) install

hexo: submodules
	@echo -e "\033[32m[HEXO   ]\033[0m \c"
	node_modules/hexo/bin/hexo generate

cimod: genver
	@echo -e "\033[32m[GENVER ]\033[0m Generating build info for CI...\c"
	@sed -i 's/default/CI/g' modify/genver
	@echo -e "ok"

ci: cimod hexo

clean: 
	@echo -e "\033[32m[CLEAN  ]\033[0m node_modules/" && rm -rf node_modules/
	@echo -e "\033[32m[CLEAN  ]\033[0m themes/tranquilpeak/" && rm -rf themes/tranquilpeak/
	@echo -e "\033[32m[CLEAN  ]\033[0m public/" && rm -rf public/

substash: 
	@echo -e "\033[32m[S-STASH]\033[0m \c" && cd themes/tranquilpeak && git stash
