# Change Log

## [Unreleased](https://github.com/rupa/z/tree/HEAD)

[Full Changelog](https://github.com/rupa/z/compare/v1.11...HEAD)

**Closed issues:**

- Typo in README.md [\#222](https://github.com/rupa/z/issues/222)
- Feature Request: Go to next best match? [\#208](https://github.com/rupa/z/issues/208)
- Current stable release version? [\#205](https://github.com/rupa/z/issues/205)
- Suggestion: Z is awesome. It would be great to have a similar command for history. [\#188](https://github.com/rupa/z/issues/188)
- Jump too simple [\#187](https://github.com/rupa/z/issues/187)
- Is the name somehow connected with Charlie the unicorn? [\#167](https://github.com/rupa/z/issues/167)
- Support Symlinked Datafile [\#154](https://github.com/rupa/z/issues/154)
- How to install the c version? [\#135](https://github.com/rupa/z/issues/135)
- Access a directory up to the latest matching regex [\#127](https://github.com/rupa/z/issues/127)

**Merged pull requests:**

- Use `index\(s, t\)` instead of regular expression [\#214](https://github.com/rupa/z/pull/214) ([ericbn](https://github.com/ericbn))

## [v1.11](https://github.com/rupa/z/tree/v1.11) (2017-06-18)
[Full Changelog](https://github.com/rupa/z/compare/v1.10...v1.11)

## [v1.10](https://github.com/rupa/z/tree/v1.10) (2017-06-18)
[Full Changelog](https://github.com/rupa/z/compare/v1.9...v1.10)

**Closed issues:**

- z doesn't record cd [\#202](https://github.com/rupa/z/issues/202)
- z hangs shell on macOS Sierra [\#194](https://github.com/rupa/z/issues/194)
- Fails under zsh [\#192](https://github.com/rupa/z/issues/192)
- Update datafile in background for speed [\#191](https://github.com/rupa/z/issues/191)
- man path update [\#186](https://github.com/rupa/z/issues/186)
- options not work due to unrecognized modifier `1' [\#185](https://github.com/rupa/z/issues/185)
- Project active? [\#183](https://github.com/rupa/z/issues/183)
- \[feature request\] echo the current working directory [\#180](https://github.com/rupa/z/issues/180)
- .z stops updating when the last directory in ~/.z does not exist [\#177](https://github.com/rupa/z/issues/177)
- Can't pipe result of `z -t` [\#176](https://github.com/rupa/z/issues/176)
- Nothing being written to ~/.z [\#175](https://github.com/rupa/z/issues/175)
- Make use of pushd [\#162](https://github.com/rupa/z/issues/162)
- "brew install awk" breaks z [\#150](https://github.com/rupa/z/issues/150)
- z with zsh 4.3.9 not working [\#66](https://github.com/rupa/z/issues/66)

**Merged pull requests:**

- Check intended exit code. Fixes \#177. [\#178](https://github.com/rupa/z/pull/178) ([paulp](https://github.com/paulp))

## [v1.9](https://github.com/rupa/z/tree/v1.9) (2015-09-13)
[Full Changelog](https://github.com/rupa/z/compare/v1.8...v1.9)

**Closed issues:**

- License? [\#160](https://github.com/rupa/z/issues/160)
- List entries with tab delimiter [\#156](https://github.com/rupa/z/issues/156)
- not creating .z in archlinux [\#149](https://github.com/rupa/z/issues/149)
- z not creating .z file in zsh [\#147](https://github.com/rupa/z/issues/147)
- alias path='echo -e ${PATH//:/\\n}' breaks z [\#144](https://github.com/rupa/z/issues/144)
- z - [\#142](https://github.com/rupa/z/issues/142)
- error 'sed: 1: extra characters at the end of d command' when using -x option [\#141](https://github.com/rupa/z/issues/141)
- z acts like in zsh when ran from tmux [\#140](https://github.com/rupa/z/issues/140)
- .z isn't created [\#139](https://github.com/rupa/z/issues/139)
- Permission denied [\#134](https://github.com/rupa/z/issues/134)
- z -x sed error on OS X [\#125](https://github.com/rupa/z/issues/125)
- Exclude wildcard [\#124](https://github.com/rupa/z/issues/124)
- array plusequal use breaks old bash [\#122](https://github.com/rupa/z/issues/122)
- Can get it to install [\#120](https://github.com/rupa/z/issues/120)
- typo: $tmpfile should be $tempfile [\#115](https://github.com/rupa/z/issues/115)
- \_Z\_NO\_RESOLVE\_SYMLINKS isn't recognized on OS X 10.8.4 [\#114](https://github.com/rupa/z/issues/114)
- z appears to not recognize a dot as a literal dot [\#113](https://github.com/rupa/z/issues/113)
- terminal hangs when sourcing bashrc [\#112](https://github.com/rupa/z/issues/112)
- How to source z.sh in eshell? [\#108](https://github.com/rupa/z/issues/108)
- I get ERROR: z.sh is meant to be sourced... whenever I run a shell script [\#107](https://github.com/rupa/z/issues/107)
- stray temporary files [\#84](https://github.com/rupa/z/issues/84)
- Can't install z with zsh version 5.0.0 with oh-my-zsh [\#77](https://github.com/rupa/z/issues/77)
- Can't install z on zsh 4.3.12 \(x86\_64-redhat-linux-gnu\) [\#67](https://github.com/rupa/z/issues/67)
- Try to find an approximate match by popping the pattern list [\#40](https://github.com/rupa/z/issues/40)
- Windows support? [\#5](https://github.com/rupa/z/issues/5)

**Merged pull requests:**

- Fix special char escaping so `mawk` likes it [\#152](https://github.com/rupa/z/pull/152) ([somasis](https://github.com/somasis))
- commit c507bdd broke zsh -- this fixes it [\#148](https://github.com/rupa/z/pull/148) ([tomhoover](https://github.com/tomhoover))
- Allow usage of z while in 'sudo -s' mode [\#137](https://github.com/rupa/z/pull/137) ([dan-bolsun](https://github.com/dan-bolsun))
- use command pwd instead of pwd [\#132](https://github.com/rupa/z/pull/132) ([lge88](https://github.com/lge88))
- Prevent extraneous shifting [\#130](https://github.com/rupa/z/pull/130) ([notwa](https://github.com/notwa))
- redirect to /dev/null instead of '-q' option for solaris 10 or earlier [\#109](https://github.com/rupa/z/pull/109) ([uchida](https://github.com/uchida))

## [v1.8](https://github.com/rupa/z/tree/v1.8) (2013-07-07)
[Full Changelog](https://github.com/rupa/z/compare/v1.7...v1.8)

**Closed issues:**

- Errors when sshing to account which is sourcing z.sh [\#106](https://github.com/rupa/z/issues/106)
- PROMPT\_COMMAND error [\#105](https://github.com/rupa/z/issues/105)
- Z issue with scp [\#104](https://github.com/rupa/z/issues/104)
- Version 1.7 release [\#102](https://github.com/rupa/z/issues/102)

## [v1.7](https://github.com/rupa/z/tree/v1.7) (2013-06-10)
[Full Changelog](https://github.com/rupa/z/compare/v1.6...v1.7)

**Closed issues:**

- In Git Bash no mktemp [\#103](https://github.com/rupa/z/issues/103)
- Bug [\#101](https://github.com/rupa/z/issues/101)
- fish shell support? [\#95](https://github.com/rupa/z/issues/95)
- command not found issue | OS X 10.8.3 [\#89](https://github.com/rupa/z/issues/89)
- what is the license of this project? [\#88](https://github.com/rupa/z/issues/88)

**Merged pull requests:**

- Fix a few typos [\#98](https://github.com/rupa/z/pull/98) ([baskerville](https://github.com/baskerville))
- New option: -x [\#94](https://github.com/rupa/z/pull/94) ([baskerville](https://github.com/baskerville))

## [v1.6](https://github.com/rupa/z/tree/v1.6) (2013-03-18)
[Full Changelog](https://github.com/rupa/z/compare/v1.5...v1.6)

**Closed issues:**

- Promp command installation failing [\#85](https://github.com/rupa/z/issues/85)
- Feature: optionally only consider dirs below cwd \(like autojump's "jc"\) [\#83](https://github.com/rupa/z/issues/83)
- Output of "set"? [\#82](https://github.com/rupa/z/issues/82)
- License [\#81](https://github.com/rupa/z/issues/81)
- Symlinks to Folders [\#80](https://github.com/rupa/z/issues/80)
- add a warning about installing z to .profile instead of .bashrc [\#79](https://github.com/rupa/z/issues/79)
- Not jumping after creating dir [\#74](https://github.com/rupa/z/issues/74)
- Can't work tab completion   [\#72](https://github.com/rupa/z/issues/72)

**Merged pull requests:**

- Deal with spaces in $HOME [\#86](https://github.com/rupa/z/pull/86) ([matthiasgoergens](https://github.com/matthiasgoergens))

## [v1.5](https://github.com/rupa/z/tree/v1.5) (2013-01-22)
[Full Changelog](https://github.com/rupa/z/compare/v1.4...v1.5)

**Closed issues:**

- printing out `\_z:17: = not found` after every command [\#75](https://github.com/rupa/z/issues/75)
- I must be missing something. [\#73](https://github.com/rupa/z/issues/73)
- Exclude [\#71](https://github.com/rupa/z/issues/71)
- Option to restrict matching to parent and/or child directories  [\#70](https://github.com/rupa/z/issues/70)
- Feature Request: SSH support [\#69](https://github.com/rupa/z/issues/69)
- -t flag selects the least, instead of most, recent matching entry [\#68](https://github.com/rupa/z/issues/68)
- Spelling: s/frecent/frequent/ [\#63](https://github.com/rupa/z/issues/63)
- extend path cache duration? [\#53](https://github.com/rupa/z/issues/53)

**Merged pull requests:**

- More groff\_man-ish coding style [\#78](https://github.com/rupa/z/pull/78) ([ntsuji](https://github.com/ntsuji))
- You only need one '=' character to check if something is equal [\#76](https://github.com/rupa/z/pull/76) ([nmeum](https://github.com/nmeum))

## [v1.4](https://github.com/rupa/z/tree/v1.4) (2012-09-01)
[Full Changelog](https://github.com/rupa/z/compare/v1.3...v1.4)

**Closed issues:**

- Can't seem to get it working :/ [\#60](https://github.com/rupa/z/issues/60)
- autojump? [\#59](https://github.com/rupa/z/issues/59)
- Parenthesis in path gives syntax error [\#58](https://github.com/rupa/z/issues/58)
- Please add this to ohmyzsh plugins [\#57](https://github.com/rupa/z/issues/57)
- Allow selection from list \(as in 'v'\) [\#42](https://github.com/rupa/z/issues/42)

**Merged pull requests:**

- remove double cdargs mention [\#62](https://github.com/rupa/z/pull/62) ([aeosynth](https://github.com/aeosynth))

## [v1.3](https://github.com/rupa/z/tree/v1.3) (2012-08-10)
[Full Changelog](https://github.com/rupa/z/compare/v1.2...v1.3)

**Closed issues:**

- Anything special on installing at bash ? [\#55](https://github.com/rupa/z/issues/55)

## [v1.2](https://github.com/rupa/z/tree/v1.2) (2012-07-04)
[Full Changelog](https://github.com/rupa/z/compare/v1.1...v1.2)

**Closed issues:**

- Problematic Characters in Path? [\#54](https://github.com/rupa/z/issues/54)
- Storing symlinks [\#52](https://github.com/rupa/z/issues/52)
- Question about installation [\#51](https://github.com/rupa/z/issues/51)
- Including Position inside path in frecency [\#50](https://github.com/rupa/z/issues/50)
- Store symlinks rather than true links [\#49](https://github.com/rupa/z/issues/49)
- Running z with no arguments in a directory increases its frecency [\#47](https://github.com/rupa/z/issues/47)
- z tab complete adding an open quote [\#46](https://github.com/rupa/z/issues/46)
- z is not working [\#45](https://github.com/rupa/z/issues/45)
- bash completion breaks exit status display in prompt [\#44](https://github.com/rupa/z/issues/44)
- Doesn't seem to work with custom data file [\#43](https://github.com/rupa/z/issues/43)
- Performance Improvement: Replace the Use of `system\(test\)` with an Awk Builtin Function [\#41](https://github.com/rupa/z/issues/41)
- add install instructions to readme [\#38](https://github.com/rupa/z/issues/38)
- misspelling [\#37](https://github.com/rupa/z/issues/37)
- quick suggestion [\#36](https://github.com/rupa/z/issues/36)
- z cannot work on zsh? [\#34](https://github.com/rupa/z/issues/34)
- \[Request\] Using z with Vim \(MacVim\) [\#29](https://github.com/rupa/z/issues/29)
- tcsh support? [\#15](https://github.com/rupa/z/issues/15)

## [v1.1](https://github.com/rupa/z/tree/v1.1) (2011-08-07)
[Full Changelog](https://github.com/rupa/z/compare/v1.0...v1.1)

**Closed issues:**

- \[Request\] print the matched directory to STDOUT [\#33](https://github.com/rupa/z/issues/33)
- Broken, leaves empty tmpfiles [\#31](https://github.com/rupa/z/issues/31)
- z prints to STDERR [\#28](https://github.com/rupa/z/issues/28)
- ls -l output is different [\#25](https://github.com/rupa/z/issues/25)
- touch ~/.z [\#24](https://github.com/rupa/z/issues/24)
- Subshells 'command not found' fix [\#20](https://github.com/rupa/z/issues/20)
- fuzzy matching [\#19](https://github.com/rupa/z/issues/19)
- z doesnt play nice with sudo -s  \(and other things\) [\#17](https://github.com/rupa/z/issues/17)
- syntax error using bash 4.2 [\#14](https://github.com/rupa/z/issues/14)
- Add "cd" features [\#7](https://github.com/rupa/z/issues/7)

**Merged pull requests:**

- pull request: use actual return status; don't truncate file when disk full [\#30](https://github.com/rupa/z/pull/30) ([Enlik](https://github.com/Enlik))
- Allow spaces in directory names \(fix only works for zsh\) [\#27](https://github.com/rupa/z/pull/27) ([simonair](https://github.com/simonair))

## [v1.0](https://github.com/rupa/z/tree/v1.0) (2011-02-28)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*