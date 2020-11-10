/* 
 * Description: display .desktop files content found on system
 *     Application-Name command
 * Version:  0.1
 * Licence:  MIT
 * Author:  Xavier Cartron prx@ybad.name
 * TODO : locale
 */

#include <ctype.h>
#include <err.h>
#include <errno.h>
#include <dirent.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define LEN(X)               (sizeof X / sizeof X[0])
#define PLEDGEORDIE(prom) if (pledge(prom, NULL) == -1) { err(1, "pledge"); } 

void *       ecalloc(size_t nmemb, size_t size);
int          efclose(FILE *stream);
FILE *       efopen(const char *path, const char *mode);
void *       ereallocarray(void *ptr, size_t nmemb, size_t size);
int          endswith(const char *str, const char *end);
size_t       esnprintf(char *str, size_t size, const char *fmt, ...);
char *       estrdup(const char *s);
int          filter_desktop(const struct dirent *d);
char *       get_desktop_item(const char *f, const char *item);
void         print_name(const char *f);
void         print_exec(const char *f);
void         print_category(const char *f);
void         trim(char **str);
int          startswith(const char *str, const char *start);

static const char *categories[][2] = {
	{ "Graphics", "Graphics" },
	{ "Development", "Development" },
	{ "Settings", "Settings" },
	{ "System", "System" },
	{ "Utility", "Utility" },
	{ "Game", "Game" },
	{ "Network", "Network" },
	{ "Office", "Office" },
	{ "Audio", "Multimedia" },
	{ "Video", "Multimedia" },
};
static const char *misc = "Misc";

void *
ecalloc(size_t nmemb, size_t size)
{
	void *p;


	if ((p = calloc(nmemb, size)) == NULL)
		err(1, "calloc");
	return p;
}

void *
ereallocarray(void *ptr, size_t nmemb, size_t size)
{
	if ((ptr = reallocarray(ptr, nmemb, size)) == NULL)
		err(1, "reallocarray");

	return ptr;
}

int
efclose(FILE *stream)
{
	int ret = 0;


	ret = fclose(stream);
	if (ferror(stream)) {
		err(1,"closefile");
	}
	return ret;
}

FILE *
efopen(const char *path, const char *mode)
{
	FILE *f = NULL;


	if ((f = fopen(path, mode)) == NULL)
		err(1, "%s: %s", "Fail to open", path);

	return f;
}

size_t
esnprintf(char *str, size_t size, const char *fmt, ...)
{
    va_list ap;
    size_t ret = 0;


    va_start(ap, fmt);
    ret = vsnprintf(str, size, fmt, ap);
    if (ret < 0) {
        err(1,"vsnprintf:");
    } else if (ret >= size) {
        err(1,"vsnprintf: Output truncated");
	}

    va_end(ap);

    return ret;
}

char *
estrdup(const char *s)
{
	char *p = strdup(s);


	if (p == NULL)
		err(1, "strdup");

	return p;
}

int 
startswith(const char *str, const char *start)
{
	size_t str_len = strlen(str);
	size_t start_len = strlen(start);


	int ret = 0;
	if ((str_len >= start_len) && 
		(strncmp(str, start, start_len) == 0)) {
		ret = 1;
	}

	return ret;
}

int
endswith(const char *str, const char *end)
{
  size_t str_len = strlen(str);
  size_t end_len = strlen(end);

  int ret = 0;
  if ((str_len >= end_len) &&
    (strcmp(str + (str_len -end_len), end) == 0)) {
    ret = 1;
  }

  return ret;
}

char *
get_desktop_item(const char *f, const char *item)
{
	char *match = NULL;
	char *tmp = NULL;
	char *line = NULL;
	size_t linesize = 0;
	ssize_t linelen;
	FILE *fp;


	fp = efopen(f, "r");

	while ((linelen = getline(&line, &linesize, fp)) != -1) {
		if (startswith(line, item)) {
			tmp = strsep(&line, "=");
			trim(&line);
			match = estrdup(line);
			break;
		}
	}

	free(tmp);
	if (ferror(fp)) {
		err(1, "getline");
	}

	efclose(fp);
	return match;
}

void
print_name(const char *f)
{
	char *res              = NULL;
	char l[3]              = {'\0'};
	char namel[10]         = {'\0'};
	const char *lang       = getenv("LANG");
	
	
	strncpy(l, lang, 2);
	esnprintf(namel, sizeof(namel), "Name=[%s]", l);
	res = get_desktop_item(f, namel);
	if (res == NULL) {
		res = get_desktop_item(f, "Name=");
	}
	printf("%s", res);
	free(res);
}

void
print_category(const char *f)
{
	char *res              = NULL;
	

	res = get_desktop_item(f, "Categories=");
	if (res != NULL) {
		for (size_t k = 0; k < LEN(categories); k++) {
			if (strstr(res, categories[k][0]) != NULL) {
				printf("%s", categories[k][1]);
				break;
			}
		}
	} else {
		printf("%s", misc);
	}
	free(res);
}

void
print_exec(const char *f)
{
	char *res              = NULL;
	char *tmp              = NULL;
	

	/* remove %f and stuff */
	res = get_desktop_item(f, "Exec=");
	tmp = strsep(&res, "%");

	printf("%s", tmp);
	free(tmp);
}

int
filter_desktop(const struct dirent *d)
{
	int ret = 0;
	const char *homedir     = getenv("HOME");
	char exclude[BUFSIZ] = {'\0'};
	char *line = NULL;
	FILE *fp;
	size_t linesize = 0;
	ssize_t linelen;

	/* exclude list is in ~/.config/lsdesktop.exclude */
	esnprintf(exclude, sizeof(exclude), "%s/.config/lsdesktop.exclude", homedir);


	if (endswith(d->d_name, ".desktop")) {
		ret = 1;

		if (access(exclude, F_OK ) != -1 ) {
			fp = efopen(exclude, "r");
			while ((linelen = getline(&line, &linesize, fp)) != -1) {
				trim(&line);
				if (strcmp(d->d_name, line) == 0) {
					ret = 0;
					break;
				}
			}

			free(line);
			if (ferror(fp)) {
				err(1, "getline");
			}

			efclose(fp);
		}
	} 

	return ret;
}

/* return a trimmed copy of str */
/* trim(&str); */
void
trim(char **str)
{
    size_t begin = 0;
    size_t end = strlen(*str);


    while (isspace((*str)[begin])) {
        begin++;
    }

    while (isspace((*str)[end-1])) {
        end--;
    }
    for (size_t i = begin, j=0; i < end; i++, j++) {
        (*str)[j] = (*str)[i];
    }
    (*str)[end - begin] = '\0';
}

int 
main (int argc, char *argv[])
{
#ifdef __OpenBSD__
	PLEDGEORDIE("stdio rpath cpath wpath");
#endif

	int n                   = 0;
	char *sep               = "|";
	char *item              = NULL;
	char homedirapp[BUFSIZ] = {'\0'};
	char desktop[BUFSIZ]    = {'\0'};
	const char *homedir     = getenv("HOME");
	struct dirent **namelist;


	if (argc == 2) {
		if (strcmp(argv[1], "-h") == 0) {
			printf("usage: %s [-h|-s]\n", argv[0]);
			printf("    -h: show this message\n");
			printf("    -s: set separator string between name and command\n\n");
			printf("every filename listed in ~/.config/lsdesktop.exclude"
				" will be ignored (one per line)\n");
			exit(0);
		}
	} else if (argc == 3) {
		sep = argv[2];
	}

	esnprintf(homedirapp, sizeof(homedirapp), "%s/.local/share/applications", homedir);
	/* .desktop files directories */
	const char *dfd[] = { 
		"/usr/local/share/applications",
		"/usr/share/applications", 
		homedirapp
	};

	for (size_t i = 0; i < LEN(dfd); i++) {
		if ((n = scandir(dfd[i], &namelist, filter_desktop, NULL)) < 0) {
			warn("scandir:%s", dfd[i]);
		} else {
			for(int j = 0; j < n; j++) {
				esnprintf(desktop, sizeof(desktop), "%s/%s",
					dfd[i], namelist[j]->d_name);

				print_category(desktop);
				printf("%s", sep);
				print_name(desktop);
				printf("%s", sep);
				print_exec(desktop);
				printf("\n");
				free(namelist[j]);
			}
			free(namelist);
		}
	}

	return 0;
}
