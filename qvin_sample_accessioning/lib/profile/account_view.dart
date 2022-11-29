import 'package:flutter/material.dart';
import 'package:qvin_sample_accessioning/shared/components/avatar.dart';
import 'package:qvin_sample_accessioning/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const AccountView(),
    );
  }

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _firstNameController = TextEditingController();
  final _profileURLController = TextEditingController();
  final _humanIdController = TextEditingController();
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = false;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('person')
          .select()
          .eq('id', userId)
          .single() as Map;
      _firstNameController.text = (data['first_name'] ?? '') as String;
      _humanIdController.text = (data['human_id'] ?? '') as String;
      _profileURLController.text = (data['profile_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected exception occurred');
    }

    setState(() {
      _loading = false;
    });
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final firstName = _firstNameController.text;
    final profileURL = _profileURLController.text;
    final humanId = _humanIdController.text;
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'first_name': firstName,
      'human_id': humanId,
      // 'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('person').upsert(updates);
      if (mounted) {
        context.showSnackBar(message: 'Successfully updated profile!');
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpeted error occurred');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error occurred');
    }
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _profileURLController.dispose();
    _humanIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        flexibleSpace: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/account');
                  },
                  child: Row(
                    children: [
                      if (_profileURLController.text.isEmpty)
                        Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey,
                          child: const Center(
                            child: Text('No Image'),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.network(
                            _profileURLController.text,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _firstNameController.text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/accession');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.science_rounded,
                          size: 16,
                          semanticLabel: 'Accession Sample',
                        ),
                        const SizedBox(width: 4),
                        const Text('Accession'),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    )),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: _signOut,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 16,
                          semanticLabel: 'Sign Out',
                        ),
                        const SizedBox(width: 4),
                        const Text('Sign Out'),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    )),
                const SizedBox(width: 8),
              ],
            )),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Avatar(
                        imageUrl: _profileURLController.text,
                        onUpload: (String) {
                          print('slkdjf');
                        },
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const SizedBox(height: 18),
                          Text(_humanIdController.text),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _firstNameController,
                            decoration:
                                const InputDecoration(labelText: 'First Name'),
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _profileURLController,
                            decoration: const InputDecoration(
                                labelText: 'Profile Image'),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: _updateProfile,
                            child: Text(_loading ? 'Saving...' : 'Update'),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
