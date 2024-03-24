build-runner:
	dart run build_runner build --delete-conflicting-outputs

clean:
	flutter clean
	make build-runner