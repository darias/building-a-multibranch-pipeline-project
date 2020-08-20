#!/usr/bin/env bash
  
usage() {
        echo "Usage: $0 --release <release>"
}


RELEASE=

while [ $# -gt 0 ]; do
        case "$1" in
        --release)
                shift; RELEASE=$1
                case "$RELEASE" in
                        dev|qa|prod)
                        ;;
                        *)
                                echo "ERROR unrecognized release $RELEASE"
                                exit 1
                        ;;
                esac
                ;;

        -h|--help)
                usage; exit 0 ;;

        *)
                echo "ERROR Unrecognized flag $1"; exit 1 ;;
        esac
        shift
done

if [ -z "$RELEASE" ]; then
        echo "ERROR missing --release arg"
        exit 1
fi

BRANCH=`git branch |grep '*'|cut -d ' ' -f 2`
if [ "$BRANCH" -ne "master" ]; then
	echo "ERROR need to run in master branch"
	exit 1
fi

echo CHECKOUT $RELEASE
git checkout $RELEASE
echo PULL
git pull . master
echo PUSH
git push --set-upstream origin $RELEASE

echo RESTORE master
git checkout master
