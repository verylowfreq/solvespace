//-----------------------------------------------------------------------------
// The GTK-based implementation of platform-dependent GUI functionality.
//
// Copyright 2018 whitequark
//-----------------------------------------------------------------------------
#include <errno.h>
#include <sys/stat.h>
#include <unistd.h>
#include <json-c/json_object.h>
#include <json-c/json_util.h>

#include "solvespace.h"

namespace SolveSpace {
namespace Platform {

class SettingsJsonStore : public Settings {
public:
    Path _path;
    json_obj *_json = NULL;


    SettingsJsonStore(std::string jsonpath);

    virtual ~SettingsJsonStore();
};
}
}
