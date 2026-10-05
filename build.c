#ifdef __APPLE__
#  include <sys/stat.h>
#  include <unistd.h>
#elif _WIN32
#  define _CRT_SECURE_NO_WARNINGS
#  define _CRT_NONSTDC_NO_WARNINGS
#  include <direct.h>
#  include <process.h>
#else
#  error Unsupported platform
#endif

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int run(char ** args) {
  assert(args && args[0]);

#ifdef __APPLE__
  pid_t pid = fork();
  if (pid == 0) {
    execvp(args[0], args);
    abort();
  } else if (pid > 0) {
    int sl = 0;
    assert(0 <= waitpid(pid, &sl, 0));
    if (WIFEXITED(sl)) return WEXITSTATUS(sl);
  }
#elif _WIN32
  if (0 == _spawnvp(_P_WAIT, args[0], (const char * const *)args)) {
    return 0;
  }
#endif

  fprintf(stderr, "failed to run child process: %s\n", args[0]);
  return 1;
}
#define RUN(...) do { char * args[] = { __VA_ARGS__, 0 }; if (run(args)) return 1; } while (0)

#ifdef _WIN32
static int dxc(const char * model, const char * entry, const char * src, const char * out) {
  char * win_kit_version = getenv("WIN_KIT_VERSION");
  if (!win_kit_version) return (fprintf(stderr, "missing environment WIN_KIT_VERSION"), 1);

  char argv0[1024];
  snprintf(argv0, 1024,
      "c:\\Program Files (x86)\\Windows Kits\\10\\bin\\%s\\x64\\dxc.exe",
      win_kit_version);

  RUN(argv0, "-T", strdup(model), "-E", strdup(entry), strdup(src), "-Fo", strdup(out));
  return 0;
}
#endif

int main() {
#ifdef __APPLE__
  RUN("xcrun", "-sdk", "macosx", "metal", "example.metal", "-o", "example.metallib");
#elif _WIN32
  if (dxc("vs_5_0", "main", "example.hlsl", "example.dxil")) return 1;
#endif
  return 0;
}

