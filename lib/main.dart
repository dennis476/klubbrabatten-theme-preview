// Standalone Flutter Web preview of the Klubbrabatten in-app föreningstema.
// Embedded by the admin (Lovable) via an <iframe>; the accent colour + logo +
// name come from the URL query string:
//   ?primary=%23F2C200&logo=<logo-url>&name=Vaksala%20SK&city=Solna
//
// Faithful replica of the REAL Home v2 (verified against home_page.dart /
// home_page_content.dart / home_offers_chips_section.dart / chip_offer_card.dart
// / user_support_seller_widget.dart / ludde_card.dart), rendered in the dark
// föreningstema. Real order: HomeHeader → search → CHIP SECTION (pill selector +
// VERTICAL list of 4 offer rows) → category rail → Stötta-kort → Ludde-kort →
// Nyheter. Same dark tokens + assets as the app.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const ClubThemePreviewApp());

// ── Dark base tokens (match lib/globals/club_theme.dart) ─────────────────────
const Color _bgTop = Color(0xFF15161A);
const Color _bgBottom = Color(0xFF0D0E11);
const Color _surface = Color(0xFF1C1D21);
const Color _surfaceText = Color(0xFFFFFFFF);
const Color _surfaceSub = Color(0xFF9EA8B7);
const Color _orange = Color(0xFFF27B36);
const String _font = 'DM Sans';

Color _parseHex(String? hex) {
  if (hex == null) return const Color(0xFF2D7BE0);
  final s = hex.replaceFirst('#', '').trim();
  if (s.length != 6) return const Color(0xFF2D7BE0);
  final v = int.tryParse(s, radix: 16);
  return v == null ? const Color(0xFF2D7BE0) : Color(0xFF000000 | v);
}

Color _onColor(Color p) =>
    p.computeLuminance() > 0.5 ? const Color(0xFF1A1A1E) : Colors.white;

class ClubThemePreviewApp extends StatelessWidget {
  const ClubThemePreviewApp({super.key});
  @override
  Widget build(BuildContext context) {
    final q = Uri.base.queryParameters;
    final primary = _parseHex(q['primary']);
    final logo = q['logo'];
    final name = (q['name'] == null || q['name']!.trim().isEmpty)
        ? 'Din förening'
        : q['name']!.trim();
    final city = q['city'];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: _font),
      home: Scaffold(
        backgroundColor: const Color(0xFFE9ECF1),
        body: Center(
          child: _Phone(
            child: _Home(primary: primary, logoUrl: logo, name: name, city: city),
          ),
        ),
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 844,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        border: Border.all(color: const Color(0xFF111317), width: 10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 20)),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(34), child: child),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home(
      {required this.primary,
      required this.logoUrl,
      required this.name,
      required this.city});
  final Color primary;
  final String? logoUrl;
  final String name;
  final String? city;

  @override
  Widget build(BuildContext context) {
    final onP = _onColor(primary);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.alphaBlend(primary.withValues(alpha: 0.22), _bgTop),
            _bgTop,
            _bgBottom,
          ],
          stops: const [0.0, 0.26, 1.0],
        ),
        image: (logoUrl != null && logoUrl!.isNotEmpty)
            ? DecorationImage(
                image: NetworkImage(logoUrl!),
                alignment: const Alignment(0.55, -0.62),
                scale: 1.55,
                fit: BoxFit.none,
                opacity: 0.15)
            : null,
      ),
      child: Column(children: [
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            const SizedBox(height: 14),
            _statusBar(),
            const SizedBox(height: 12),
            _headerRow(),
            const SizedBox(height: 8),
            _locationRow(),
            const SizedBox(height: 12),
            _searchBar(),
            const SizedBox(height: 18),
            _chipSection(onP),
            const SizedBox(height: 8),
            _categoryRail(),
            const SizedBox(height: 16),
            _stottaCard(onP),
            const SizedBox(height: 12),
            _luddeCard(),
            const SizedBox(height: 20),
            _sectionTitle('Nyheter'),
            const SizedBox(height: 8),
            _newsCard(),
            const SizedBox(height: 24),
          ]),
        ),
        _navBar(),
      ]),
    );
  }

  Widget _statusBar() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('09:41',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
          Row(children: [
            Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
            SizedBox(width: 5),
            Icon(Icons.wifi, color: Colors.white, size: 16),
            SizedBox(width: 5),
            Icon(Icons.battery_full, color: Colors.white, size: 18),
          ]),
        ]),
      );

  // HomeHeader top row: logo (h34) + 48px glass notification (3D mailbox).
  Widget _headerRow() => Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 20, 0),
        child: Row(children: [
          Image.asset('assets/brand/header_logo_dark.webp',
              height: 34, fit: BoxFit.contain, alignment: Alignment.centerLeft),
          const Spacer(),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/ic_notification_3d.png', fit: BoxFit.contain),
          ),
        ]),
      );

  Widget _locationRow() => const Padding(
        padding: EdgeInsets.fromLTRB(22, 0, 20, 0),
        child: Row(children: [
          Icon(Icons.location_on, color: Color(0xFFC8CED8), size: 18),
          SizedBox(width: 6),
          Text('Solna • Inom 50 km',
              style: TextStyle(
                  color: Color(0xFFC8CED8),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500)),
          Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFC8CED8), size: 18),
        ]),
      );

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: const Row(children: [
            Icon(Icons.search, color: Color(0xFF8A94A6), size: 20),
            SizedBox(width: 12),
            Text('Sök affärer',
                style: TextStyle(
                    color: Color(0xFF8A94A6),
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );

  // CHIP SECTION: pill selector (Flest inlösen / Trendar just nu / Nyheter) +
  // a VERTICAL list of 4 offer rows (chip_offer_card). Dark-themed.
  Widget _chipSection(Color onP) {
    const pills = ['Flest inlösen', 'Trendar just nu', 'Nyheter'];
    final offers = [
      ['Stadium', 'Sport & träning', '25%', '1,5 km', '1 248'],
      ['ICA Maxi', 'Mat & dryck', '15%', '1,2 km', '982'],
      ['Pizza Hut', 'Restaurang', '30%', '0,8 km', '743'],
      ['Apotek Hjärtat', 'Hälsa', '20%', '2,1 km', '511'],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // pill bar
      SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: pills.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final sel = i == 0;
            return Container(
              padding: const EdgeInsets.fromLTRB(14, 9, 16, 9),
              decoration: BoxDecoration(
                color: sel ? primary.withValues(alpha: 0.18) : _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: sel
                        ? primary.withValues(alpha: 0.55)
                        : const Color(0xFF2E3036)),
              ),
              alignment: Alignment.center,
              child: Text(pills[i],
                  style: TextStyle(
                      color: sel ? primary : _surfaceSub,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      // section header
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Flest inlösen',
              style: TextStyle(
                  color: _surfaceText, fontSize: 17, fontWeight: FontWeight.w700)),
          Row(children: [
            Text('Visa alla',
                style: TextStyle(
                    color: primary, fontSize: 13, fontWeight: FontWeight.w600)),
            Icon(Icons.chevron_right_rounded, color: primary, size: 18),
          ]),
        ]),
      ),
      const SizedBox(height: 10),
      // VERTICAL list of 4 offer rows
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            for (final o in offers)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: _surface, borderRadius: BorderRadius.circular(18)),
                child: Row(children: [
                  // image + discount badge
                  Stack(children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          color: const Color(0xFF2A2C33),
                          borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.local_offer,
                          color: Color(0xFF565963), size: 22),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFF2655A), Color(0xFFD81F1F)]),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Text(o[2],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 9.5)),
                      ),
                    ),
                  ]),
                  const SizedBox(width: 12),
                  // name + title + meta
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o[0],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: _surfaceText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(o[1],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: _surfaceSub,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.5)),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.location_on_rounded,
                                size: 12, color: _surfaceSub),
                            const SizedBox(width: 2),
                            Text(o[3],
                                style: const TextStyle(
                                    color: _surfaceSub,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 8, 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF2A2D34),
                                  borderRadius: BorderRadius.circular(999)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.confirmation_number_outlined,
                                    size: 12, color: _surfaceSub),
                                const SizedBox(width: 4),
                                Text(o[4],
                                    style: const TextStyle(
                                        color: Color(0xFFD7DCE5),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600)),
                              ]),
                            ),
                          ]),
                        ]),
                  ),
                  const SizedBox(width: 8),
                  // favorite heart
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: Color(0xFF26282F), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border,
                        size: 18, color: _surfaceSub),
                  ),
                ]),
              ),
          ],
        ),
      ),
    ]);
  }

  Widget _categoryRail() {
    const cats = <List<String>>[
      ['Alla', 'alla'],
      ['Livsmedel', 'livsmedel'],
      ['Restaurang & Café', 'restaurang-cafe'],
      ['Sport & Fritid', 'sport-fritid'],
      ['Fordon', 'fordon'],
      ['Mode', 'mode'],
      ['Hem & Elektronik', 'hem-elektronik'],
      ['Hälsa & Skönhet', 'halsa-skonhet'],
      ['Aktiviteter', 'aktiviteter'],
      ['Onlinerabatter', 'onlinerabatter'],
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final sel = i == 0;
          return SizedBox(
            width: 62,
            child: Column(children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F6),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: sel ? _orange : Colors.transparent, width: 2),
                ),
                child: Image.asset('assets/cat/${cats[i][1]}.webp',
                    width: 40, height: 40),
              ),
              const SizedBox(height: 7),
              Text(cats[i][0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                      color: sel ? _orange : const Color(0xFFC8CED8))),
            ]),
          );
        },
      ),
    );
  }

  // Stötta din förening (UserSupportSellerWidget) — dark themed.
  Widget _stottaCard(Color onP) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              // navy crest badge with the club logo
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF101826),
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (logoUrl != null && logoUrl!.isNotEmpty)
                      ? Image.network(logoUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.shield_outlined, color: Colors.white))
                      : const Icon(Icons.shield_outlined, color: Colors.white),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stötta $name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: _surfaceText,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(city == null || city!.isEmpty ? 'Allsvenskan' : city!,
                          style: const TextStyle(
                              color: _surfaceSub, fontSize: 13)),
                    ]),
              ),
              const Icon(Icons.chevron_right, color: _surfaceSub, size: 22),
            ]),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('62% av mål',
                  style: TextStyle(
                      color: _surfaceText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700)),
              Row(children: [
                const Text('Sålda ',
                    style: TextStyle(
                        color: _surfaceSub,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
                Text('62',
                    style: TextStyle(
                        color: primary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700)),
                const Text('/100',
                    style: TextStyle(color: _surfaceSub, fontSize: 12.5)),
              ]),
            ]),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(children: [
                Container(height: 9, color: const Color(0xFF33353C)),
                FractionallySizedBox(
                    widthFactor: 0.62,
                    child: Container(height: 9, color: primary)),
              ]),
            ),
            const SizedBox(height: 9),
            Row(children: [
              const Expanded(
                child: Text('38 köp kvar till milstolpe',
                    style: TextStyle(
                        color: _surfaceSub, fontSize: 12.5, height: 1.2)),
              ),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(24)),
                child: Text('Köp nu',
                    style: TextStyle(
                        color: onP, fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              const SizedBox(width: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF80868F))),
                child: const Text('Dela',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ),
            ]),
          ]),
        ),
      );

  // Ludde card (navy gradient + input + send) — unchanged by the theme, as in app.
  Widget _luddeCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A60AB), Color(0xFF112E58)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFF1B3A66), shape: BoxShape.circle),
                child: const Icon(Icons.smart_toy_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Fråga Ludde',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.5)),
                      SizedBox(height: 2),
                      Text('Chatboten från Klubbrabatten',
                          style: TextStyle(
                              color: Color(0xB8FFFFFF), fontSize: 12)),
                    ]),
              ),
              const Icon(Icons.auto_awesome, color: Color(0xFFF7B27A), size: 20),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: const Text('Ställ en fråga...',
                      style: TextStyle(color: Color(0x8CFFFFFF), fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    color: Color(0xFF13315F), size: 20),
              ),
            ]),
          ]),
        ),
      );

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const Text('Visa alla',
              style: TextStyle(color: _surfaceSub, fontSize: 13)),
        ]),
      );

  Widget _newsCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  color: Color(0xFF2A2C33),
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(16))),
              child: const Icon(Icons.local_pizza, color: Color(0xFF6B7280)),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ny aktör: Pizza Hut Uppsala',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      SizedBox(height: 4),
                      Text('En ny aktör har lagts till i Uppsala.',
                          style:
                              TextStyle(color: _surfaceSub, fontSize: 12)),
                    ]),
              ),
            ),
          ]),
        ),
      );

  Widget _navBar() {
    const items = [
      ['Hem', 'assets/nav/nav_tab_home.svg'],
      ['Favoriter', 'assets/nav/nav_tab_favorite.svg'],
      ['Karta', 'assets/nav/nav_tab_map.svg'],
      ['Community', 'assets/nav/nav_tab_community.svg'],
      ['Profil', 'assets/nav/nav_tab_profile.svg'],
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
      decoration: const BoxDecoration(color: Color(0xFF16171B)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < items.length; i++)
            Column(mainAxisSize: MainAxisSize.min, children: [
              SvgPicture.asset(items[i][1],
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                      i == 0 ? primary : const Color(0xFFA3ABB8),
                      BlendMode.srcIn)),
              const SizedBox(height: 4),
              Text(items[i][0],
                  style: TextStyle(
                      color: i == 0 ? primary : const Color(0xFFA3ABB8),
                      fontSize: 11,
                      fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w500)),
            ]),
        ],
      ),
    );
  }
}
