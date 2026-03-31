import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/models/airport.dart';
import 'package:flight_app/widgets/range_date_picker.dart';

class FlightSearchHome extends StatefulWidget {
  const FlightSearchHome({super.key});

  @override
  State<FlightSearchHome> createState() => _FlightSearchHomeState();
}

class _FlightSearchHomeState extends State<FlightSearchHome>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Trip type
  String _tripType = 'One-way';
  final List<String> _tripTypes = ['One-way', 'Round-trip'];

  // Selected airports
  Airport? _fromAirport;
  Airport? _toAirport;

  // Dates
  DateTime? _departureDate;
  DateTime? _returnDate;

  // Passengers
  int _adults = 1;
  int _children = 0;
  int _infants = 0;

  // Cabin class
  String _cabinClass = 'Economy';
  final List<String> _cabinClasses = [
    'Economy',
    'Premium Economy',
    'Business',
    'First Class'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();

    // Pre-fill destination if coming from Explore destination card
    final args = Get.arguments;
    if (args is Map && args['toCode'] != null) {
      final code = args['toCode'] as String;
      try {
        _toAirport = airportList.firstWhere((a) => a.code == code);
      } catch (_) {
        // Code not found in list — leave null, user picks manually
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _swapAirports() {
    setState(() {
      final temp = _fromAirport;
      _fromAirport = _toAirport;
      _toAirport = temp;
    });
  }

  Future<void> _selectDepartureDate() async {
    if (_tripType == 'Round-trip') {
      // Open the range picker so the user selects both dates at once
      final range = await RangeDatePickerSheet.show(
        context,
        startLabel: 'Departure',
        endLabel: 'Return',
        initialStart: _departureDate,
        initialEnd: _returnDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        singleDate: false,
      );
      if (range != null) {
        setState(() {
          _departureDate = range.start;
          _returnDate = range.end != range.start ? range.end : null;
        });
      }
    } else {
      final range = await RangeDatePickerSheet.show(
        context,
        startLabel: 'Departure',
        initialStart: _departureDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        singleDate: true,
      );
      if (range != null) {
        setState(() {
          _departureDate = range.start;
          if (_returnDate != null && _returnDate!.isBefore(_departureDate!)) {
            _returnDate = null;
          }
        });
      }
    }
  }

  Future<void> _selectReturnDate() async {
    if (_tripType != 'Round-trip') return;
    final range = await RangeDatePickerSheet.show(
      context,
      startLabel: 'Departure',
      endLabel: 'Return',
      initialStart: _departureDate,
      initialEnd: _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      singleDate: false,
    );
    if (range != null) {
      setState(() {
        _departureDate = range.start;
        _returnDate = range.end != range.start ? range.end : null;
      });
    }
  }

  void _showPassengerPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(spacingUnit(3)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: spacingUnit(2)),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const Text('Passengers', style: ThemeText.title2),
                  SizedBox(height: spacingUnit(3)),

                  // Adults
                  _buildPassengerRow(
                    'Adults',
                    '12+ years',
                    _adults,
                    (val) {
                      // Min 1 adult; max 9 total passengers
                      final maxAllowed = 9 - _children - _infants;
                      if (val >= 1 && val <= maxAllowed) {
                        // Clamp infants to not exceed new adult count
                        final newInfants = _infants > val ? val : _infants;
                        setModalState(() {
                          _adults = val;
                          _infants = newInfants;
                        });
                        setState(() {
                          _adults = val;
                          _infants = newInfants;
                        });
                      }
                    },
                    minCount: 1,
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Children
                  _buildPassengerRow(
                    'Children',
                    '2-11 years',
                    _children,
                    (val) {
                      final maxAllowed = 9 - _adults - _infants;
                      if (val >= 0 && val <= maxAllowed) {
                        setModalState(() => _children = val);
                        setState(() => _children = val);
                      }
                    },
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Infants (cannot exceed adults; total must stay ≤ 9)
                  _buildPassengerRow(
                    'Infants',
                    'Under 2 years',
                    _infants,
                    (val) {
                      final maxInfants = _adults < (9 - _adults - _children)
                          ? _adults
                          : (9 - _adults - _children);
                      if (val >= 0 && val <= maxInfants) {
                        setModalState(() => _infants = val);
                        setState(() => _infants = val);
                      }
                    },
                  ),

                  SizedBox(height: spacingUnit(3)),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme(context).primary,
                      foregroundColor: colorScheme(context).onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Done'),
                  ),

                  SizedBox(height: spacingUnit(2)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPassengerRow(
      String title, String subtitle, int count, Function(int) onChanged,
      {int minCount = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ThemeText.subtitle),
            Text(subtitle, style: ThemeText.caption),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: count > minCount ? () => onChanged(count - 1) : null,
              icon: Icon(
                CupertinoIcons.minus_circle_fill,
                color: count > minCount
                    ? colorScheme(context).primary
                    : Colors.grey,
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(
                '$count',
                style: ThemeText.subtitle,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () => onChanged(count + 1),
              icon: Icon(
                CupertinoIcons.plus_circle_fill,
                color: colorScheme(context).primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectAirport(bool isFrom) async {
    final Airport? selected = await showModalBottomSheet<Airport>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AirportSearchBottomSheet(
        excludeAirport: isFrom ? _toAirport : _fromAirport,
      ),
    );

    if (selected != null) {
      setState(() {
        if (isFrom) {
          _fromAirport = selected;
        } else {
          _toAirport = selected;
        }
      });
    }
  }

  void _searchFlights() {
    if (_fromAirport == null || _toAirport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select departure and arrival airports')),
      );
      return;
    }

    if (_departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select departure date')),
      );
      return;
    }

    if (_tripType == 'Round-trip' && _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select return date')),
      );
      return;
    }

    // Navigate to flight results
    Get.toNamed(
      '/flight-results',
      arguments: {
        'tripType': _tripType,
        'fromAirport': _fromAirport,
        'toAirport': _toAirport,
        'departureDate': _departureDate,
        'returnDate': _returnDate,
        'adults': _adults,
        'children': _children,
        'infants': _infants,
        'cabinClass': _cabinClass,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPassengers = _adults + _children + _infants;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // ── Premium Fintech Header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFFD4AF37), size: 18),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD4AF37),
                      Color(0xFFDAB853),
                      Color(0xFFE8C76A),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: constraints.maxHeight > 120 ? 24 : 16,
                          bottom: 8,
                        ),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.flight_takeoff_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Flight Booking',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: -0.8,
                                              height: 1.1,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Discover flights effortlessly',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white
                                                  .withValues(alpha: 0.9),
                                              letterSpacing: 0.2,
                                              height: 1.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Trip type selector
                  Container(
                    color: colorScheme(context).surface,
                    padding: EdgeInsets.all(spacingUnit(2)),
                    child: Row(
                      children: _tripTypes.map((type) {
                        final isSelected = _tripType == type;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: spacingUnit(0.5)),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _tripType = type;
                                  if (type != 'Round-trip') {
                                    _returnDate = null;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: spacingUnit(1.5)),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme(context).primary
                                      : colorScheme(context)
                                          .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? colorScheme(context).primary
                                        : Colors.grey.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: isSelected
                                        ? colorScheme(context).onPrimary
                                        : colorScheme(context).onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // From and To airports
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    decoration: BoxDecoration(
                      color: colorScheme(context).surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // From
                        InkWell(
                          onTap: () => _selectAirport(true),
                          child: Container(
                            padding: EdgeInsets.all(spacingUnit(2)),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.airplane,
                                  color: colorScheme(context).primary,
                                ),
                                SizedBox(width: spacingUnit(2)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('From',
                                          style: ThemeText.caption),
                                      SizedBox(height: spacingUnit(0.5)),
                                      Text(
                                        _fromAirport?.location ??
                                            'Select departure city',
                                        style: ThemeText.subtitle,
                                      ),
                                      if (_fromAirport != null)
                                        Text(
                                          _fromAirport!.name,
                                          style: ThemeText.caption,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                if (_fromAirport != null)
                                  Text(
                                    _fromAirport!.code,
                                    style: ThemeText.title2.copyWith(
                                      color: colorScheme(context).primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Swap button
                        Divider(
                            height: 1,
                            color: Colors.grey.withValues(alpha: 0.2)),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: _swapAirports,
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ThemePalette.primaryMain,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                color: ThemePalette.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                            height: 1,
                            color: Colors.grey.withValues(alpha: 0.2)),

                        // To
                        InkWell(
                          onTap: () => _selectAirport(false),
                          child: Container(
                            padding: EdgeInsets.all(spacingUnit(2)),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.airplane,
                                  color: colorScheme(context).primary,
                                ),
                                SizedBox(width: spacingUnit(2)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('To',
                                          style: ThemeText.caption),
                                      SizedBox(height: spacingUnit(0.5)),
                                      Text(
                                        _toAirport?.location ??
                                            'Select arrival city',
                                        style: ThemeText.subtitle,
                                      ),
                                      if (_toAirport != null)
                                        Text(
                                          _toAirport!.name,
                                          style: ThemeText.caption,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                if (_toAirport != null)
                                  Text(
                                    _toAirport!.code,
                                    style: ThemeText.title2.copyWith(
                                      color: colorScheme(context).primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Dates
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    child: Row(
                      children: [
                        // Departure date
                        Expanded(
                          child: InkWell(
                            onTap: _selectDepartureDate,
                            child: Container(
                              padding: EdgeInsets.all(spacingUnit(2)),
                              decoration: BoxDecoration(
                                color: colorScheme(context).surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.calendar,
                                        size: 20,
                                        color: colorScheme(context).primary,
                                      ),
                                      SizedBox(width: spacingUnit(1)),
                                      const Text('Departure',
                                          style: ThemeText.caption),
                                    ],
                                  ),
                                  SizedBox(height: spacingUnit(1)),
                                  Text(
                                    _departureDate != null
                                        ? '${_departureDate!.day} ${_getMonthName(_departureDate!.month)}'
                                        : 'Select date',
                                    style: ThemeText.subtitle,
                                  ),
                                  if (_departureDate != null)
                                    Text(
                                      _getDayName(_departureDate!.weekday),
                                      style: ThemeText.caption,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        if (_tripType == 'Round-trip') ...[
                          SizedBox(width: spacingUnit(2)),
                          // Return date
                          Expanded(
                            child: InkWell(
                              onTap: _selectReturnDate,
                              child: Container(
                                padding: EdgeInsets.all(spacingUnit(2)),
                                decoration: BoxDecoration(
                                  color: colorScheme(context).surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.calendar,
                                          size: 20,
                                          color: colorScheme(context).primary,
                                        ),
                                        SizedBox(width: spacingUnit(1)),
                                        const Text('Return',
                                            style: ThemeText.caption),
                                      ],
                                    ),
                                    SizedBox(height: spacingUnit(1)),
                                    Text(
                                      _returnDate != null
                                          ? '${_returnDate!.day} ${_getMonthName(_returnDate!.month)}'
                                          : 'Select date',
                                      style: ThemeText.subtitle,
                                    ),
                                    if (_returnDate != null)
                                      Text(
                                        _getDayName(_returnDate!.weekday),
                                        style: ThemeText.caption,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Passengers and Class
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    child: Row(
                      children: [
                        // Passengers
                        Expanded(
                          child: InkWell(
                            onTap: _showPassengerPicker,
                            child: Container(
                              padding: EdgeInsets.all(spacingUnit(2)),
                              decoration: BoxDecoration(
                                color: colorScheme(context).surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.person_2,
                                        size: 20,
                                        color: colorScheme(context).primary,
                                      ),
                                      SizedBox(width: spacingUnit(1)),
                                      const Text('Passengers',
                                          style: ThemeText.caption),
                                    ],
                                  ),
                                  SizedBox(height: spacingUnit(1)),
                                  Text(
                                    '$totalPassengers ${totalPassengers == 1 ? "Passenger" : "Passengers"}',
                                    style: ThemeText.subtitle,
                                  ),
                                  Text(
                                    'A: $_adults, C: $_children, I: $_infants',
                                    style: ThemeText.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: spacingUnit(2)),

                        // Cabin class
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme(context).surface,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                  ),
                                  padding: EdgeInsets.all(spacingUnit(3)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Grabber
                                      Container(
                                        width: 40,
                                        height: 4,
                                        margin: EdgeInsets.only(
                                            bottom: spacingUnit(2)),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      const Text('Cabin Class',
                                          style: ThemeText.title2),
                                      SizedBox(height: spacingUnit(3)),
                                      ..._cabinClasses.map((cabinClass) {
                                        final isSelected =
                                            _cabinClass == cabinClass;
                                        IconData classIcon;
                                        Color classColor;

                                        switch (cabinClass) {
                                          case 'Economy':
                                            classIcon = Icons
                                                .airline_seat_recline_normal;
                                            classColor = Colors.blue;
                                            break;
                                          case 'Premium Economy':
                                            classIcon = Icons
                                                .airline_seat_recline_extra;
                                            classColor = Colors.purple;
                                            break;
                                          case 'Business':
                                            classIcon = Icons.airline_seat_flat;
                                            classColor = Colors.orange;
                                            break;
                                          case 'First Class':
                                            classIcon =
                                                Icons.airline_seat_flat_angled;
                                            classColor = Colors.amber;
                                            break;
                                          default:
                                            classIcon = Icons.event_seat;
                                            classColor = Colors.grey;
                                        }

                                        return Container(
                                          margin: EdgeInsets.only(
                                              bottom: spacingUnit(1.5)),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelected
                                                  ? colorScheme(context).primary
                                                  : Colors.grey
                                                      .withValues(alpha: 0.3),
                                              width: isSelected ? 2 : 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: isSelected
                                                ? colorScheme(context)
                                                    .primary
                                                    .withValues(alpha: 0.1)
                                                : Colors.transparent,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() =>
                                                  _cabinClass = cabinClass);
                                              Navigator.pop(context);
                                            },
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: spacingUnit(2),
                                                vertical: spacingUnit(1.5),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                        spacingUnit(1)),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          classColor.withValues(
                                                              alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Icon(
                                                      classIcon,
                                                      color: classColor,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: spacingUnit(2)),
                                                  Expanded(
                                                    child: Text(
                                                      cabinClass,
                                                      style: ThemeText.subtitle
                                                          .copyWith(
                                                        fontWeight: isSelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Radio<String>(
                                                    value: cabinClass,
                                                    groupValue: _cabinClass,
                                                    activeColor:
                                                        colorScheme(context)
                                                            .primary,
                                                    onChanged: (value) {
                                                      setState(() =>
                                                          _cabinClass =
                                                              cabinClass);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                      SizedBox(height: spacingUnit(2)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(spacingUnit(2)),
                              decoration: BoxDecoration(
                                color: colorScheme(context).surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.checkmark_seal,
                                        size: 20,
                                        color: colorScheme(context).primary,
                                      ),
                                      SizedBox(width: spacingUnit(1)),
                                      const Text('Class',
                                          style: ThemeText.caption),
                                    ],
                                  ),
                                  SizedBox(height: spacingUnit(1)),
                                  Text(
                                    _cabinClass,
                                    style: ThemeText.subtitle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacingUnit(10)),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky bottom button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: colorScheme(context).surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _searchFlights,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme(context).primary,
              foregroundColor: colorScheme(context).onPrimary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.search),
                SizedBox(width: spacingUnit(1)),
                const Text(
                  'Search Flights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }
}

// Airport Search Bottom Sheet
class _AirportSearchBottomSheet extends StatefulWidget {
  final Airport? excludeAirport;

  const _AirportSearchBottomSheet({this.excludeAirport});

  @override
  State<_AirportSearchBottomSheet> createState() =>
      _AirportSearchBottomSheetState();
}

class _AirportSearchBottomSheetState extends State<_AirportSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Airport> _filteredAirports = airportList;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterAirports);
  }

  void _filterAirports() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAirports = airportList.where((airport) {
        return airport.location.toLowerCase().contains(query) ||
            airport.name.toLowerCase().contains(query) ||
            airport.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(spacingUnit(2)),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: spacingUnit(2)),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Text('Select Airport', style: ThemeText.title2),
              SizedBox(height: spacingUnit(2)),

              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by city, airport or code',
                  prefixIcon: const Icon(CupertinoIcons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(CupertinoIcons.clear_circled_solid),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
              ),

              SizedBox(height: spacingUnit(2)),

              // Airport list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filteredAirports.length,
                  itemBuilder: (context, index) {
                    final airport = _filteredAirports[index];
                    final isExcluded = widget.excludeAirport?.id == airport.id;

                    return ListTile(
                      enabled: !isExcluded,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isExcluded
                              ? Colors.grey.withValues(alpha: 0.2)
                              : const Color(0xFFD4AF37).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          CupertinoIcons.airplane,
                          color: isExcluded
                              ? Colors.grey
                              : const Color(0xFFD4AF37),
                        ),
                      ),
                      title: Text(
                        airport.location,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isExcluded ? Colors.grey : null,
                        ),
                      ),
                      subtitle: Text(
                        airport.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isExcluded ? Colors.grey : null,
                        ),
                      ),
                      trailing: Text(
                        airport.code,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isExcluded
                              ? Colors.grey
                              : const Color(0xFFD4AF37),
                        ),
                      ),
                      onTap: isExcluded
                          ? null
                          : () {
                              Navigator.pop(context, airport);
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
