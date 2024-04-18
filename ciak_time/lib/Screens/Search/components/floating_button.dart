import 'package:ciak_time/components/out_apply_button_filter.dart';
import 'package:ciak_time/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({
    Key key,
    @required this.selectedTerm,
    @required this.callback,
  }) : super(key: key);

  final Function callback;
  final String selectedTerm;

  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FloatingActionButton.extended(
        label: Text(
          language.filters,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: height * 0.02,
            fontFamily: 'Quicksand-Medium',
          ),
        ),
        icon: SvgPicture.asset(
          "assets/icons/setting-lines.svg",
          width: width * 0.06,
        ),
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onPressed: () {
          setState(
            () {
              FocusManager.instance.primaryFocus.unfocus();
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: width * 0.75,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      language.order_by,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.03,
                                          fontFamily: 'Quicksand-Medium',
                                          color: filterTitleColor),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Row(
                                children: [
                                  FilterChip(
                                    label: Container(
                                      width: width * 0.2,
                                      child: Text(
                                        language.rate_filter,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    labelStyle: TextStyle(color: colorRate),
                                    checkmarkColor: colorRate,
                                    backgroundColor: Colors.transparent,
                                    selectedColor: filterSelectedColor,
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: borderFilterColor,
                                            width: width * 0.0055)),
                                    selected: selected_rate,
                                    onSelected: (bool value) {
                                      setState(() {
                                        selected_rate = !selected_rate;
                                        selected_most_added = false;
                                        selected_most_recent = false;
                                        if (isDarkMode) {
                                          if (!selected_rate) {
                                            colorRate = Colors.white;
                                          } else {
                                            colorRate = Colors.black;
                                            colorMostAdded = Colors.white;
                                            colorMostRecent = Colors.white;
                                          }
                                        } else {
                                          if (!selected_rate) {
                                            colorRate = Colors.black;
                                          } else {
                                            colorRate = Colors.white;
                                            colorMostAdded = Colors.black;
                                            colorMostRecent = Colors.black;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  FilterChip(
                                    label: Container(
                                      width: width * 0.2,
                                      child: Text(
                                        language.most_added,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    labelStyle:
                                        TextStyle(color: colorMostAdded),
                                    checkmarkColor: colorMostAdded,
                                    backgroundColor: Colors.transparent,
                                    selectedColor: filterSelectedColor,
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: borderFilterColor,
                                            width: width * 0.0055)),
                                    selected: selected_most_added,
                                    onSelected: (bool value) {
                                      setState(() {
                                        selected_most_added =
                                            !selected_most_added;
                                        selected_rate = false;
                                        selected_most_recent = false;
                                        if (isDarkMode) {
                                          if (!selected_most_added) {
                                            colorMostAdded = Colors.white;
                                          } else {
                                            colorMostAdded = Colors.black;
                                            colorMostRecent = Colors.white;
                                            colorRate = Colors.white;
                                          }
                                        } else {
                                          if (!selected_most_added) {
                                            colorMostAdded = Colors.black;
                                          } else {
                                            colorMostAdded = Colors.white;
                                            colorMostRecent = Colors.black;
                                            colorRate = Colors.black;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FilterChip(
                                    label: Container(
                                      width: width * 0.2,
                                      child: Text(
                                        language.most_recent,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    labelStyle:
                                        TextStyle(color: colorMostRecent),
                                    checkmarkColor: colorMostRecent,
                                    backgroundColor: Colors.transparent,
                                    selectedColor: filterSelectedColor,
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: borderFilterColor,
                                            width: width * 0.0055)),
                                    selected: selected_most_recent,
                                    onSelected: (bool value) {
                                      setState(() {
                                        selected_most_recent =
                                            !selected_most_recent;
                                        selected_rate = false;
                                        selected_most_added = false;

                                        if (isDarkMode) {
                                          if (!selected_most_recent) {
                                            colorMostRecent = Colors.white;
                                          } else {
                                            colorMostRecent = Colors.black;
                                            colorMostAdded = Colors.white;
                                            colorRate = Colors.white;
                                          }
                                        } else {
                                          if (!selected_most_recent) {
                                            colorMostRecent = Colors.black;
                                          } else {
                                            colorMostRecent = Colors.white;
                                            colorMostAdded = Colors.black;
                                            colorRate = Colors.black;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              Container(
                                width: width * 0.75,
                                child: Text(
                                  language.genre,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03,
                                      fontFamily: 'Quicksand-Medium',
                                      color: filterTitleColor),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.drama,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorDrama),
                                          checkmarkColor: colorDrama,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: drama,
                                          onSelected: (bool value) {
                                            setState(() {
                                              drama = !drama;
                                              if (isDarkMode) {
                                                if (!drama) {
                                                  colorDrama = Colors.white;
                                                } else {
                                                  colorDrama = Colors.black;
                                                }
                                              } else {
                                                if (!drama) {
                                                  colorDrama = Colors.black;
                                                } else {
                                                  colorDrama = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.comedy,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorComedy),
                                          checkmarkColor: colorComedy,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: comedy,
                                          onSelected: (bool value) {
                                            setState(() {
                                              comedy = !comedy;
                                              if (isDarkMode) {
                                                if (!comedy) {
                                                  colorComedy = Colors.white;
                                                } else {
                                                  colorComedy = Colors.black;
                                                }
                                              } else {
                                                if (!comedy) {
                                                  colorComedy = Colors.black;
                                                } else {
                                                  colorComedy = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.action,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorAction),
                                          checkmarkColor: colorAction,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: action,
                                          onSelected: (bool value) {
                                            setState(() {
                                              action = !action;
                                              if (isDarkMode) {
                                                if (!action) {
                                                  colorAction = Colors.white;
                                                } else {
                                                  colorAction = Colors.black;
                                                }
                                              } else {
                                                if (!action) {
                                                  colorAction = Colors.black;
                                                } else {
                                                  colorAction = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.crime,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorCrime),
                                          checkmarkColor: colorCrime,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: crime,
                                          onSelected: (bool value) {
                                            setState(() {
                                              crime = !crime;
                                              if (isDarkMode) {
                                                if (!crime) {
                                                  colorCrime = Colors.white;
                                                } else {
                                                  colorCrime = Colors.black;
                                                }
                                              } else {
                                                if (!crime) {
                                                  colorCrime = Colors.black;
                                                } else {
                                                  colorCrime = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.fantasy,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: colorFantasy,
                                          ),
                                          checkmarkColor: colorFantasy,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: fantasy,
                                          onSelected: (bool value) {
                                            setState(() {
                                              fantasy = !fantasy;
                                              if (isDarkMode) {
                                                if (!fantasy) {
                                                  colorFantasy = Colors.white;
                                                } else {
                                                  colorFantasy = Colors.black;
                                                }
                                              } else {
                                                if (!fantasy) {
                                                  colorFantasy = Colors.black;
                                                } else {
                                                  colorFantasy = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.thriller,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorThriller),
                                          checkmarkColor: colorThriller,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: thriller,
                                          onSelected: (bool value) {
                                            setState(() {
                                              thriller = !thriller;
                                              if (isDarkMode) {
                                                if (!thriller) {
                                                  colorThriller = Colors.white;
                                                } else {
                                                  colorThriller = Colors.black;
                                                }
                                              } else {
                                                if (!thriller) {
                                                  colorThriller = Colors.black;
                                                } else {
                                                  colorThriller = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.family,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorFamily),
                                          checkmarkColor: colorFamily,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: family,
                                          onSelected: (bool value) {
                                            setState(() {
                                              family = !family;
                                              if (isDarkMode) {
                                                if (!family) {
                                                  colorFamily = Colors.white;
                                                } else {
                                                  colorFamily = Colors.black;
                                                }
                                              } else {
                                                if (!family) {
                                                  colorFamily = Colors.black;
                                                } else {
                                                  colorFamily = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.animation,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorAnime),
                                          checkmarkColor: colorAnime,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: anime,
                                          onSelected: (bool value) {
                                            setState(() {
                                              anime = !anime;
                                              if (isDarkMode) {
                                                if (!anime) {
                                                  colorAnime = Colors.white;
                                                } else {
                                                  colorAnime = Colors.black;
                                                }
                                              } else {
                                                if (!anime) {
                                                  colorAnime = Colors.black;
                                                } else {
                                                  colorAnime = Colors.white;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        FilterChip(
                                          label: Container(
                                            width: width * 0.2,
                                            child: Text(
                                              language.horror,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: colorHorror),
                                          checkmarkColor: colorHorror,
                                          backgroundColor: Colors.transparent,
                                          selectedColor: filterSelectedColor,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: borderFilterColor,
                                                  width: width * 0.0055)),
                                          selected: horror,
                                          onSelected: (bool value) {
                                            setState(
                                              () {
                                                horror = !horror;
                                                if (isDarkMode) {
                                                  if (!horror) {
                                                    colorHorror = Colors.white;
                                                  } else {
                                                    colorHorror = Colors.black;
                                                  }
                                                } else {
                                                  if (!horror) {
                                                    colorHorror = Colors.black;
                                                  } else {
                                                    colorHorror = Colors.white;
                                                  }
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              SizedBox(
                                height: height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isReset = true;
                                        deselectAllFilters();
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      primary: resetBackgroundColor,
                                      minimumSize:
                                          Size(width * 0.25, height * 0.05),
                                      backgroundColor: resetBackgroundColor,
                                      side: BorderSide(
                                          color: resetBorderColor, width: 2),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                    ),
                                    child: Text(
                                      language.reset,
                                      style: TextStyle(
                                        color: resetColor,
                                        fontSize: width * 0.04,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.05),
                                  OutApplyButtonFilter(
                                    callback: widget.callback,
                                    selectedTerm: widget.selectedTerm,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void deselectAllFilters() {
    if (isReset == true) {
      drama = false;
      comedy = false;
      action = false;
      crime = false;
      fantasy = false;
      thriller = false;
      family = false;
      anime = false;
      horror = false;
      selected_rate = false;
      selected_most_added = false;
      selected_most_recent = false;
      if (isDarkMode) {
        colorRate = Colors.white;
        colorMostAdded = Colors.white;
        colorMostRecent = Colors.white;
        colorDrama = Colors.white;
        colorComedy = Colors.white;
        colorAction = Colors.white;
        colorCrime = Colors.white;
        colorFantasy = Colors.white;
        colorThriller = Colors.white;
        colorFamily = Colors.white;
        colorAnime = Colors.white;
        colorHorror = Colors.white;
      } else {
        colorRate = Colors.black;
        colorMostAdded = Colors.black;
        colorMostRecent = Colors.black;
        colorDrama = Colors.black;
        colorComedy = Colors.black;
        colorAction = Colors.black;
        colorCrime = Colors.black;
        colorFantasy = Colors.black;
        colorThriller = Colors.black;
        colorFamily = Colors.black;
        colorAnime = Colors.black;
        colorHorror = Colors.black;
      }
    }
  }
}
