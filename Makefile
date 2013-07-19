
hypotrochoid:
	cd src; elm --make --noscript --minify --runtime=elm-runtime.js Hypotrochoid.elm
	mv src/Hypotrochoid.html build/.
	cp lib/elm-runtime.js build/.
 
clean:
	rm -rf build/*
