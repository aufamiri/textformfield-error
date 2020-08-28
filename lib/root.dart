import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _formKey = GlobalKey<FormState>();

  final _departureTextController = TextEditingController();

  final _arrivalTextController = TextEditingController();

  DateTime _departureDate;
  DateTime _arrivalDate;

  bool _isPulangPergi = false;

  bool _valideResult;

  void _show({
    @required BuildContext context,
    @required Function(DateTime) onSaved,
  }) async {
    DateTime now = DateTime.now();

    //hide keyboard from appearing
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();

    DateTime date = await showDatePicker(
      context: context,
      initialDate: now,
      lastDate:
          now.add(Duration(days: 6000)), //FIXME : cari cara buat nambah tahun
      firstDate: now,
    );

    if (date != null) {
      onSaved(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Form"),
      ),

      //body
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //left  side
                    Column(
                      children: [
                        _datePicker(
                          controller: _departureTextController,
                          context: context,
                          onSaved: (value) {
                            setState(() {
                              _departureDate = value;
                            });
                            _departureTextController.text = value.toString();
                          },
                          prefixIcon: Icon(Icons.calendar_today),
                          title: "Berangkat",
                        ),
                        _datePicker(
                          controller: _arrivalTextController,
                          context: context,
                          onSaved: (value) {
                            setState(() {
                              _arrivalDate = value;
                            });

                            _arrivalTextController.text = value.toString();
                          },
                          enabled: _isPulangPergi,
                          prefixIcon: Icon(Icons.calendar_today),
                          title: "Pulang",
                        ),
                      ],
                    ),

                    //right side
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Pulang - Pergi ?",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Container(
                          height: 40,
                          child: Switch(
                            value: _isPulangPergi,
                            onChanged: (value) {
                              setState(() {
                                _isPulangPergi = value;
                              });
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),

                //search tiket button
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width * .5,
                  child: RaisedButton(
                    child: Text("Cari Tiket"),
                    onPressed: () {
                      setState(() {
                        _valideResult = _formKey.currentState.validate();
                      });
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                      }
                    },
                  ),
                ),

                Text(_valideResult.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePicker({
    String title,
    BuildContext context,
    Widget prefixIcon,
    Function(DateTime) onSaved,
    bool enabled = true,
    TextEditingController controller,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * .6,
      child: TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: title,
            border: InputBorder.none,
            prefixIcon: prefixIcon,
          ),
          readOnly: true,
          validator: (value) => value.isEmpty ? "Harus Diisi !" : null,
          onTap: () {
            _show(
              context: context,
              onSaved: onSaved,
            );
          }),
    );
  }
}
