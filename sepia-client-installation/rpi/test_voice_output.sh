#!/bin/bash
echo "This test will generate 2 short voice outputs followed by a test-tone for 5s."
echo "Check 'pulsemixer' to adjust audio volume and device setup if you don't hear anything."
echo "If you can't select the right default device try 'alsamixer'."
echo ""
echo "1 - Now speaking ..."
espeak "This is a test, you should hear another voice output followed by a test-tone for 5 seconds"
echo "2 - Now speaking again ..."
pico2wave --lang "en-GB" --wave test.wav "This is the other voice output test."
aplay test.wav
rm test.wav
echo "3 - Here comes the test-tone ..."
speaker-test -t sine -f 600 -s1 -p5000
#spd-say "Done"
echo "DONE"
