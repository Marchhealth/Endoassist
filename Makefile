# Makefile for deploying Flutter web app to GitHub Pages

# Update These Variables
BASE_HREF = '/assist-web/'
GITHUB_REPO = https://github.com/Marchhealth/assist-web

deploy-web:
	@echo "Clean existing repository..."
	flutter clean

	@echo "Getting packages..."
	flutter pub get

	@echo "Building for web..."
	flutter build web --base-href $(BASE_HREF) --release

#	@echo "Creating CNAME file..."
#	echo "$(CUSTOM_DOMAIN)" > build/web/CNAME
	@echo "PUSH & COMMIT"
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git push -u --force origin main


	@echo "Deploying to git repository"
	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M main && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u --force origin main

	cd ../..
	@echo "🟢 Finished Deploy"

.PHONY: deploy-web