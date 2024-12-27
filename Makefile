# Makefile for deploying Flutter web app to GitHub Pages

# Update These Variables
BASE_HREF = '/'
GITHUB_REPO = https://github.com/Marchhealth/assist_web.git
#BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')
#CUSTOM_DOMAIN = pcostools.march.com
 
deploy-web:
	@echo "Clean existing repository..."
	flutter clean
 
	@echo "Getting packages..."
	flutter pub get
 
	@echo "Building for web..."
	flutter build web --base-href $(BASE_HREF) --release
 
#	@echo "Creating CNAME file..."
#	echo "$(CUSTOM_DOMAIN)" > build/web/CNAME
 
	@echo "Deploying to git repository..."
	powershell -Command """
	cd build/web; \
	git init; \
	git add .; \
	git commit -m 'Deploy Version $(1)'; \
	git branch -M main; \
	git remote add origin $(GITHUB_REPO); \
	git push -u --force origin main
	"""
	@echo "🟢 Finished Deploy"
 
.PHONY: deploy-web