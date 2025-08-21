import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class WithdrawalPage extends StatefulWidget {
  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _retypeAccountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _withdrawalAmountController = TextEditingController();

  // PAN form controllers
  final TextEditingController _panNameController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _panDobController = TextEditingController();
  String _selectedState = 'State';

  // File upload variables
  File? _panDocument;
  File? _bankDocument;
  String? _panDocumentName;
  String? _bankDocumentName;
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _indianStates = [
    'State',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f7fa),
      body: SafeArea(
        child: Column(
          children: [
            // Header Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Withdrawal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Account Verification Status Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFe8eaf6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF667eea).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.verified_user, color: Color(0xFF667eea), size: 20),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Account Verification',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2c3e50),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Mobile Number
                          _buildVerificationItem(
                            icon: Icons.phone_android,
                            iconColor: Color(0xFFffa726),
                            title: 'Mobile Number',
                            value: '9162777530',
                            status: 'verified',
                            onTap: null,
                          ),

                          SizedBox(height: 12),

                          // PAN Card
                          _buildVerificationItem(
                            icon: Icons.credit_card,
                            iconColor: Color(0xFFff7043),
                            title: 'PAN Card',
                            value: '2479HG60',
                            status: 'pending',
                            onTap: () => _showPANVerificationModal(),
                          ),

                          SizedBox(height: 12),

                          // Bank Account
                          _buildVerificationItem(
                            icon: Icons.account_balance,
                            iconColor: Color(0xFF66bb6a),
                            title: 'Bank Account',
                            value: '************0000',
                            status: 'pending',
                            onTap: () => _showBankVerificationModal(),
                          ),
                        ],
                      ),
                    ),

                    // Withdrawal Amount Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFe8eaf6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4caf50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.currency_rupee, color: Color(0xFF4caf50), size: 20),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Withdrawal Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2c3e50),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFf8f9fa),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFe0e0e0)),
                            ),
                            child: TextFormField(
                              controller: _withdrawalAmountController,
                              decoration: InputDecoration(
                                hintText: 'Enter amount to withdraw',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.currency_rupee, color: Color(0xFF667eea), size: 20),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Withdraw Button
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _processWithdrawal(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF667eea),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'WITHDRAW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String status,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFe9ecef)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2c3e50),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: status == 'verified' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            status == 'verified' ? Icons.check_circle : Icons.pending,
                            color: status == 'verified' ? Colors.green : Colors.orange,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: status == 'verified' ? Colors.green : Colors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF34495e),
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF667eea),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Enhanced file upload methods
  Future<void> _pickPANDocument() async {
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.upload_file, color: Color(0xFF667eea)),
              SizedBox(width: 8),
              Text('Select Document Source'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSourceOption(
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'Take a photo',
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              SizedBox(height: 8),
              _buildSourceOption(
                icon: Icons.photo_library,
                title: 'Gallery',
                subtitle: 'Choose from gallery',
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              SizedBox(height: 8),
              _buildSourceOption(
                icon: Icons.insert_drive_file,
                title: 'File Manager',
                subtitle: 'Browse files',
                onTap: () => Navigator.pop(context, 'files'),
              ),
            ],
          ),
        ),
      );

      if (result != null) {
        await _handleFileSelection(result, 'pan');
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting document: ${e.toString()}');
    }
  }

  Future<void> _pickBankDocument() async {
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.upload_file, color: Color(0xFF667eea)),
              SizedBox(width: 8),
              Text('Select Document Source'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSourceOption(
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'Take a photo',
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              SizedBox(height: 8),
              _buildSourceOption(
                icon: Icons.photo_library,
                title: 'Gallery',
                subtitle: 'Choose from gallery',
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              SizedBox(height: 8),
              _buildSourceOption(
                icon: Icons.insert_drive_file,
                title: 'File Manager',
                subtitle: 'Browse files',
                onTap: () => Navigator.pop(context, 'files'),
              ),
            ],
          ),
        ),
      );

      if (result != null) {
        await _handleFileSelection(result, 'bank');
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting document: ${e.toString()}');
    }
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFf8f9fa),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFe0e0e0)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF667eea).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFF667eea), size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2c3e50),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFileSelection(String source, String documentType) async {
    try {
      File? pickedFile;
      String? fileName;

      if (source == 'camera') {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          pickedFile = File(image.path);
          fileName = image.name;
        }
      } else if (source == 'gallery') {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          pickedFile = File(image.path);
          fileName = image.name;
        }
      } else if (source == 'files') {
        FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        );
        if (fileResult != null && fileResult.files.single.path != null) {
          pickedFile = File(fileResult.files.single.path!);
          fileName = fileResult.files.single.name;
        }
      }

      if (pickedFile != null && fileName != null) {
        setState(() {
          if (documentType == 'pan') {
            _panDocument = pickedFile;
            _panDocumentName = fileName;
          } else {
            _bankDocument = pickedFile;
            _bankDocumentName = fileName;
          }
        });

        _showSuccessSnackBar('${documentType.toUpperCase()} document selected successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting file: ${e.toString()}');
    }
  }

  void _removeDocument(String documentType) {
    setState(() {
      if (documentType == 'pan') {
        _panDocument = null;
        _panDocumentName = null;
      } else {
        _bankDocument = null;
        _bankDocumentName = null;
      }
    });
    _showSuccessSnackBar('${documentType.toUpperCase()} document removed');
  }

  Future<void> _uploadDocument(File document, String type) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                CircularProgressIndicator(color: Color(0xFF667eea)),
                SizedBox(width: 20),
                Expanded(child: Text('Uploading $type...', style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ),
      );

      // Simulate upload process (replace with actual API call)
      await Future.delayed(Duration(seconds: 2));

      // Close loading dialog
      Navigator.pop(context);

      _showSuccessSnackBar('$type uploaded successfully');

    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      _showErrorSnackBar('Failed to upload $type: ${e.toString()}');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _processWithdrawal() {
    if (_withdrawalAmountController.text.isEmpty) {
      _showErrorSnackBar('Please enter withdrawal amount');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Withdrawal Request'),
          ],
        ),
        content: Text('Your withdrawal request of ₹${_withdrawalAmountController.text} has been submitted and is being processed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Color(0xFF667eea))),
          ),
        ],
      ),
    );
  }

  void _showPANVerificationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Box
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF667eea).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF667eea).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF667eea),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.credit_card, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Verify PAN Card',
                          style: TextStyle(
                            color: Color(0xFF2c3e50),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Color(0xFF2c3e50)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Form Fields Box
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFf8f9fa),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFe0e0e0)),
                    ),
                    child: Column(
                      children: [
                        // Name Field
                        _buildPANFormField(
                          controller: _panNameController,
                          icon: Icons.person,
                          iconColor: Color(0xFF4caf50),
                          title: 'Name',
                          hint: 'Enter your Full Name as on PAN Card',
                          placeholder: 'XXXXX YYYYY',
                        ),

                        SizedBox(height: 25),

                        // PAN Field
                        _buildPANFormField(
                          controller: _panNumberController,
                          icon: Icons.credit_card,
                          iconColor: Color(0xFFff7043),
                          title: 'PAN',
                          hint: 'Enter your 10 - digit PAN',
                          placeholder: 'AJ******7D',
                        ),

                        SizedBox(height: 25),

                        // Date of Birth Field
                        _buildPANFormField(
                          controller: _panDobController,
                          icon: Icons.calendar_today,
                          iconColor: Color(0xFF9c27b0),
                          title: 'Date of Birth',
                          hint: 'Enter your DOB as on the PAN Card',
                          placeholder: '00/00/0000',
                        ),

                        SizedBox(height: 25),

                        // State Dropdown
                        _buildStateDropdown(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Upload Document Box
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFe0e0e0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Upload Button
                        Container(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            onPressed: _pickPANDocument,
                            icon: Icon(
                                _panDocument != null ? Icons.check_circle : Icons.upload_file,
                                color: _panDocument != null ? Colors.green : Color(0xFF4caf50)
                            ),
                            label: Text(
                              _panDocument != null ? 'PAN DOCUMENT SELECTED' : 'UPLOAD PAN PROOF',
                              style: TextStyle(
                                color: _panDocument != null ? Colors.green : Color(0xFF4caf50),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: _panDocument != null ? Colors.green : Color(0xFF4caf50),
                                  width: 2
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        // Show selected file info
                        if (_panDocument != null && _panDocumentName != null)
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.insert_drive_file, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Selected: $_panDocumentName',
                                    style: TextStyle(color: Colors.green, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red, size: 20),
                                  onPressed: () => _removeDocument('pan'),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Verify Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_panDocument != null) {
                          await _uploadDocument(_panDocument!, 'PAN document');
                          Navigator.pop(context);
                          _showSuccessSnackBar('PAN verification submitted');
                        } else {
                          _showErrorSnackBar('Please select a PAN document first');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9c27b0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'VERIFY PAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBankVerificationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Box
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF66bb6a).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF66bb6a).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF66bb6a),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.account_balance, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Verify Bank Account',
                          style: TextStyle(
                            color: Color(0xFF2c3e50),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Color(0xFF2c3e50)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Bank Form Fields Box
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFf8f9fa),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFe0e0e0)),
                    ),
                    child: Column(
                      children: [
                        // Account Number Field
                        _buildBankFormField(
                          controller: _accountController,
                          icon: Icons.account_balance_wallet,
                          iconColor: Color(0xFF2196f3),
                          title: 'Account Number',
                          hint: 'Enter your bank account number',
                          placeholder: '1234567890123456',
                        ),

                        SizedBox(height: 25),

                        // Re-type Account Number Field
                        _buildBankFormField(
                          controller: _retypeAccountController,
                          icon: Icons.refresh,
                          iconColor: Color(0xFFff9800),
                          title: 'Re-type Account Number',
                          hint: 'Re-enter your bank account number',
                          placeholder: '1234567890123456',
                        ),

                        SizedBox(height: 25),

                        // IFSC Code Field
                        _buildBankFormField(
                          controller: _ifscController,
                          icon: Icons.code,
                          iconColor: Color(0xFF9c27b0),
                          title: 'IFSC Code',
                          hint: 'Enter your bank IFSC code',
                          placeholder: 'SBIN0000123',
                        ),

                        SizedBox(height: 25),

                        // Bank Name Field
                        _buildBankFormField(
                          controller: _bankNameController,
                          icon: Icons.business,
                          iconColor: Color(0xFF4caf50),
                          title: 'Bank Name',
                          hint: 'Enter your bank name',
                          placeholder: 'State Bank of India',
                        ),

                        SizedBox(height: 25),

                        // Branch Name Field
                        _buildBankFormField(
                          controller: _branchController,
                          icon: Icons.location_on,
                          iconColor: Color(0xFFe91e63),
                          title: 'Branch Name',
                          hint: 'Enter your branch name',
                          placeholder: 'Main Branch',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Upload Bank Document Box
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFe0e0e0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Upload Button
                        Container(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            onPressed: _pickBankDocument,
                            icon: Icon(
                                _bankDocument != null ? Icons.check_circle : Icons.upload_file,
                                color: _bankDocument != null ? Colors.green : Color(0xFF66bb6a)
                            ),
                            label: Text(
                              _bankDocument != null ? 'BANK DOCUMENT SELECTED' : 'UPLOAD BANK PROOF',
                              style: TextStyle(
                                color: _bankDocument != null ? Colors.green : Color(0xFF66bb6a),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: _bankDocument != null ? Colors.green : Color(0xFF66bb6a),
                                  width: 2
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        // Show selected file info
                        if (_bankDocument != null && _bankDocumentName != null)
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.insert_drive_file, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Selected: $_bankDocumentName',
                                    style: TextStyle(color: Colors.green, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red, size: 20),
                                  onPressed: () => _removeDocument('bank'),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Verify Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_validateBankForm()) {
                          if (_bankDocument != null) {
                            await _uploadDocument(_bankDocument!, 'Bank document');
                            Navigator.pop(context);
                            _showSuccessSnackBar('Bank verification submitted');
                          } else {
                            _showErrorSnackBar('Please select a bank document first');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF66bb6a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'VERIFY BANK ACCOUNT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPANFormField({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String hint,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2c3e50),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          hint,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFe0e0e0)),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBankFormField({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String hint,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2c3e50),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          hint,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFe0e0e0)),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF2196f3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.location_city, color: Color(0xFF2196f3), size: 16),
            ),
            SizedBox(width: 8),
            Text(
              'State',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2c3e50),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Select your state',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFe0e0e0)),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedState,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: _indianStates.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(
                  state,
                  style: TextStyle(
                    fontSize: 14,
                    color: state == 'State' ? Colors.grey[400] : Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedState = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  bool _validateBankForm() {
    if (_accountController.text.isEmpty) {
      _showErrorSnackBar('Please enter account number');
      return false;
    }
    if (_retypeAccountController.text.isEmpty) {
      _showErrorSnackBar('Please re-enter account number');
      return false;
    }
    if (_accountController.text != _retypeAccountController.text) {
      _showErrorSnackBar('Account numbers do not match');
      return false;
    }
    if (_ifscController.text.isEmpty) {
      _showErrorSnackBar('Please enter IFSC code');
      return false;
    }
    if (_bankNameController.text.isEmpty) {
      _showErrorSnackBar('Please enter bank name');
      return false;
    }
    if (_branchController.text.isEmpty) {
      _showErrorSnackBar('Please enter branch name');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _retypeAccountController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _branchController.dispose();
    _withdrawalAmountController.dispose();
    _panNameController.dispose();
    _panNumberController.dispose();
    _panDobController.dispose();
    super.dispose();
  }
}